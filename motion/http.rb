module BubbleWrap

  SETTINGS = {}

  # The HTTP module provides a simple interface to make HTTP requests.
  #
  # TODO: preflight support, easier/better cookie support, better error handling
  module HTTP

    # Make a GET request and process the response asynchronously via a block.
    #
    # @examples
    #  # Simple GET request printing the body
    #   BubbleWrap::HTTP.get("https://api.github.com/users/mattetti") do |response|
    #     p response.body.to_str
    #   end
    #
    #  # GET request with basic auth credentials
    #   BubbleWrap::HTTP.get("https://api.github.com/users/mattetti", {credentials: {username: 'matt', password: 'aimonetti'}}) do |response|
    #     p response.body.to_str # prints the response's body
    #   end
    #
    def self.get(url, options={}, &block)
      options[:action] = block
      HTTP::Query.new(url, :get, options)
    end
    
    # Make a POST request
    def self.post(url, options={}, &block)
      options[:action] = block
      HTTP::Query.new(url, :post, options)
    end
    
    # Make a PUT request
    def self.put(url, options={}, &block)
      options[:action] = block
      HTTP::Query.new(url, :put, options)
    end
    
    # Make a DELETE request
    def self.delete(url, options={}, &block)
      options[:action] = block
      HTTP::Query.new(url, :delete, options)
    end

    # Make a HEAD request
    def self.head(url, options={}, &block)
      options[:action] = block
      HTTP::Query.new(url, :head, options)
    end

    # Make a PATCH request
    def self.patch(url, options={}, &block)
      options[:action] = block
      HTTP::Query.new(url, :patch, options)
    end

    # Response class wrapping the results of a Query's response
    class Response
      attr_reader :body
      attr_reader :headers
      attr_accessor :status_code, :error_message
      attr_reader :url

      def initialize(values={})
        self.update(values)
      end

      def update(values)
        values.each do |k,v|
          self.instance_variable_set("@#{k}", v)
        end
      end

      def ok?
        status_code.to_s =~ /20\d/ ? true : false
      end

    end

    # Class wrapping NSConnection and often used indirectly by the BubbleWrap::HTTP module methods.
    class Query
      attr_accessor :request
      attr_accessor :connection
      attr_accessor :credentials # username & password has a hash
      attr_accessor :proxy_credential # credential supplied to proxy servers
      attr_accessor :post_data
      attr_reader   :method

      attr_reader :response
      attr_reader :status_code
      attr_reader :response_headers
      attr_reader :response_size
      attr_reader :options

      # ==== Parameters
      # url<String>:: url of the resource to download
      # http_method<Symbol>:: Value representing the HTTP method to use
      # options<Hash>:: optional options used for the query
      #
      # ==== Options
      # :payload<String>   - data to pass to a POST, PUT, DELETE query.
      # :delegator         - Proc, class or object to call when the file is downloaded.
      # a proc will receive a Response object while the passed object
      # will receive the handle_query_response method
      # :headers<Hash>     - headers send with the request
      # Anything else will be available via the options attribute reader.
      #
      def initialize(url_string, http_method = :get, options={})
        @method = http_method.upcase.to_s
        @delegator = options.delete(:action) || self
        @payload = options.delete(:payload)
        convert_payload_to_params if @payload.is_a?(Hash)
        #not tested
        @files = options.delete(:files)
        @boundary = options.delete(:boundary) || BW.create_uuid unless @files.nil?
        #
        @credentials = options.delete(:credentials) || {}
        @credentials = {:username => '', :password => ''}.merge(@credentials)
        @timeout = options.delete(:timeout) || 30.0
        @headers = escape_line_feeds(options.delete :headers)
        @headers = {"Content-Type" => "multipart/form-data; boundary=#{@boundary}"} if @files && @headers.nil?
        @cache_policy = options.delete(:cache_policy) || NSURLRequestUseProtocolCachePolicy
        @options = options
        @response = HTTP::Response.new
        
        @url = create_url(url_string)
        @body = create_request_body
        @request = create_request
        @connection = create_connection(request, self)
        @connection.start

        UIApplication.sharedApplication.networkActivityIndicatorVisible = true
      end

      def connection(connection, didReceiveResponse:response)
        @status_code = response.statusCode
        @response_headers = response.allHeaderFields
        @response_size = response.expectedContentLength.to_f
      end

      # This delegate method get called every time a chunk of data is being received
      def connection(connection, didReceiveData:received_data)
        @received_data ||= NSMutableData.new
        @received_data.appendData(received_data)

        if download_progress = options[:download_progress]
          download_progress.call(@received_data.length.to_f, response_size)
        end
      end

      def connection(connection, willSendRequest:request, redirectResponse:redirect_response)
        log "HTTP redirected #{request.description}"
        new_request = request.mutableCopy
        # new_request.setValue(@credentials.inspect, forHTTPHeaderField:'Authorization') # disabled while we figure this one out
        new_request.setAllHTTPHeaderFields(@headers) if @headers
        @connection.cancel
        @connection = create_connection(new_request, self)
        new_request
      end

      def connection(connection, didFailWithError: error)
        log "HTTP Connection failed #{error.localizedDescription}"
        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
        @request.done_loading!
        @response.error_message = error.localizedDescription
        call_delegator_with_response
      end

      def connection(connection, didSendBodyData:sending, totalBytesWritten:written, totalBytesExpectedToWrite:expected)
        if upload_progress = options[:upload_progress]
          upload_progress.call(sending, written, expected)
        end
      end

      # The transfer is done and everything went well
      def connectionDidFinishLoading(connection)
        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
        @request.done_loading!
        response_body = NSData.dataWithData(@received_data) if @received_data
        @response.update(status_code: status_code, body: response_body, headers: response_headers, url: @url)

        call_delegator_with_response
      end

      def connection(connection, didReceiveAuthenticationChallenge:challenge)

        if (challenge.previousFailureCount == 0)
          # by default we are keeping the credential for the entire session
          # Eventually, it would be good to let the user pick one of the 3 possible credential persistence options:
          # NSURLCredentialPersistenceNone,
          # NSURLCredentialPersistenceForSession,
          # NSURLCredentialPersistencePermanent
          log "auth challenged, answered with credentials: #{credentials.inspect}"
          new_credential = NSURLCredential.credentialWithUser(credentials[:username], password:credentials[:password], persistence:NSURLCredentialPersistenceForSession)
          challenge.sender.useCredential(new_credential, forAuthenticationChallenge:challenge)
        else
          challenge.sender.cancelAuthenticationChallenge(challenge)
          log 'Auth Failed :('
        end
      end


      private

      def create_request
        log "BubbleWrap::HTTP building a NSRequest for #{@url.description}"

        request = NSMutableURLRequest.requestWithURL(@url,
                                                      cachePolicy:@cache_policy,
                                                      timeoutInterval:@timeout)
        request.setHTTPMethod(@method)
        request.setAllHTTPHeaderFields(@headers)
        request.setHTTPBody(@body)
        patch_nsurl_request(request)

        request
      end

      def create_request_body
        return nil if @method == "GET"
        return nil unless (@payload || @files)
        body = NSMutableData.data

        append_payload(body) if @payload
        append_files(body) if @files
        
        body.appendData("\r\n--#{@boundary}--\r\n".dataUsingEncoding NSUTF8StringEncoding) if @files
        body
      end

      def append_payload(body)
        if @payload.is_a?(NSData)
          body.appendData(@payload)
        else
          body.appendData(@payload.to_s.dataUsingEncoding NSUTF8StringEncoding)
        end
      end

      def append_files(body)
        @files.each do |key, value|
          postData = NSMutableData.data
          s = "\r\n--#{@boundary}\r\n"
          s += "Content-Disposition: form-data; name=\"#{key}\"; filename=\"#{key}\"\r\n"
          s += "Content-Type: application/octet-stream\r\n\r\n"
          postData.appendData(s.dataUsingEncoding NSUTF8StringEncoding)
          postData.appendData(NSData.dataWithData(value))
          postData.appendData("\r\n--#{@boundary}\r\n".dataUsingEncoding NSUTF8StringEncoding) unless key == @files.keys.last
          body.appendData(postData)
        end
      end

      def create_url(url_string)
        if @method == "GET" && @payload
          url_string += "?#{@payload}"
        end
        NSURL.URLWithString(url_string.stringByAddingPercentEscapesUsingEncoding NSUTF8StringEncoding)
      end

      def convert_payload_to_params
        params_array = generate_params(@payload)
        @payload = params_array.join("&")
      end

      def generate_params(payload, prefix=nil)
        list = []
        payload.each do |k,v|
          if v.is_a?(Hash)
            new_prefix = prefix ? "#{prefix}[#{k.to_s}]" : k.to_s
            param = generate_params(v, new_prefix)
            list << param
          elsif v.is_a?(Array)
            v.each do |val|
              param = prefix ? "#{prefix}[#{k}][]=#{val}" : "#{k}[]=#{val}"
              list << param
            end
          else
            param = prefix ? "#{prefix}[#{k}]=#{v}" : "#{k}=#{v}"
            list << param
          end
        end
        return list.flatten
      end

      def log(message)
        NSLog message if SETTINGS[:debug]
      end

      def escape_line_feeds(hash)
        return nil if hash.nil?
        escaped_hash = {}
        
        hash.each{|k,v| escaped_hash[k] = v.gsub("\n", '\\n') }
        escaped_hash
      end

      def patch_nsurl_request(request)
        request.instance_variable_set("@done_loading", false)
        
        def request.done_loading; @done_loading; end
        def request.done_loading!; @done_loading = true; end
      end

      def call_delegator_with_response
        if @delegator.respond_to?(:call)
          @delegator.call( @response, self )
        end
      end

      # This is a temporary method used for mocking.
      def create_connection(request, delegate)
        NSURLConnection.connectionWithRequest(request, delegate:delegate)
      end

    end
  end
end
