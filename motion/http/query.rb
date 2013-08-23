# Class wrapping NSConnection and often used indirectly by the BubbleWrap::HTTP module methods.
module BubbleWrap; module HTTP; class Query
  attr_accessor :request
  attr_accessor :connection
  attr_accessor :credentials # username & password has a hash
  attr_accessor :proxy_credential # credential supplied to proxy servers
  attr_accessor :post_data
  attr_reader   :method

  attr_accessor :upload_progress
  attr_accessor :download_progress

  attr_reader :response
  attr_reader :status_code
  attr_reader :response_headers
  attr_reader :response_size
  attr_reader :options
  CLRF = "\r\n"
  # ==== Parameters
  # url<String>:: url of the resource to download
  # http_method<Symbol>:: Value representing the HTTP method to use
  # options<Hash>:: optional options used for the query
  #
  # ==== Options
  # :payload<String>   - data to pass to a POST, PUT, DELETE query.
  # :action            - Proc, class or object to call when the file is downloaded.
  # a proc will receive a Response object while the passed object
  # will receive the handle_query_response method
  # :headers<Hash>     - headers send with the request
  # :cookies<Boolean>  - Set whether cookies should be sent with request or not (Default: true)
  # Anything else will be available via the options attribute reader.
  #
  def initialize(url_string, http_method = :get, options={})
    @method = http_method.upcase.to_s
    @delegator = options.delete(:action)
    @upload_progress = options.delete(:upload_progress)
    @download_progress = options.delete(:download_progress)
    @payload = options.delete(:payload)
    @encoding = options.delete(:encoding) || NSUTF8StringEncoding
    @files = options.delete(:files)
    @boundary = options.delete(:boundary) || BW.create_uuid
    @credentials = options.delete(:credentials) || {}
    @credentials = {:username => nil, :password => nil}.merge(@credentials)
    @timeout = options.delete(:timeout) || 30.0
    @headers = escape_line_feeds(options.delete :headers)
    @format = options.delete(:format)
    @cache_policy = options.delete(:cache_policy) || NSURLRequestUseProtocolCachePolicy
    @credential_persistence = options.delete(:credential_persistence) || NSURLCredentialPersistenceForSession
    @cookies = options.fetch(:cookies, true) ; options.delete(:cookies)
    @follow_urls = options.fetch(:follow_urls, true) ; options.delete(:follow_urls)
    @present_credentials = options.fetch(:present_credentials, true) ; options.delete(:present_credentials)
    autostart = options.fetch(:autostart, @delegator ? true : false) ; options.delete(:autostart)
    @started = false

    @options = options
    @response = BubbleWrap::HTTP::Response.new

    @url = create_url(url_string)
    @body = create_request_body
    @request = create_request
    @original_url = @url.copy

    if autostart
      self.start
    end

    show_status_indicator true
  end

  def start(&action)
    @delegator = action if action
    return if @started

    @started = true
    @connection = create_connection(request, self)
    @connection.scheduleInRunLoop(NSRunLoop.currentRunLoop, forMode:NSRunLoopCommonModes)
    @connection.start
  end

  def started?
    !! @started
  end

  def upload_progress(&progress)
    if progress
      @upload_progress = progress
    end
    @upload_progress
  end

  def download_progress(&progress)
    if progress
      @download_progress = progress
    end
    @download_progress
  end

  def to_s
    "#<#{self.class}:#{self.object_id} - Method: #{@method}, url: #{@url.description}, body: #{@body.description}, Payload: #{@payload}, Headers: #{@headers} Credentials: #{@credentials}, Timeout: #{@timeout}, \
Cache policy: #{@cache_policy}, response: #{@response.inspect} >"
  end
  alias description to_s

  def connection(connection, didReceiveResponse:response)
    # On OSX, if using an FTP connection, this method will fire *immediately* after creating an
    # NSURLConnection, even if the connection has not yet started. The `response`
    # object will be a NSURLResponse, *not* an `NSHTTPURLResponse`, and so will start to crash.
    if App.osx? && !response.is_a?(NSHTTPURLResponse)
      return
    end
    did_receive_response(response)
  end

  # This delegate method get called every time a chunk of data is being received
  def connection(connection, didReceiveData:received_data)
    @received_data ||= NSMutableData.new
    @received_data.appendData(received_data)

    if @download_progress
      @download_progress.call(@received_data.length.to_f, response_size)
    end
  end

  def connection(connection, willSendRequest:request, redirectResponse:redirect_response)
    # abort early if the user has explicitly disabled redirects
    if @options[:no_redirect] and redirect_response then
      return nil
    end
    @redirect_count ||= 0
    @redirect_count += 1
    log "##{@redirect_count} HTTP redirect_count: #{request.inspect} - #{self.description}"

    if @redirect_count >= 30
      @response.error = NSError.errorWithDomain('BubbleWrap::HTTP', code:NSURLErrorHTTPTooManyRedirects,
                                                userInfo:NSDictionary.dictionaryWithObject("Too many redirections",
                                                                                           forKey: NSLocalizedDescriptionKey))
      @response.error_message = @response.error.localizedDescription
      show_status_indicator false
      @request.done_loading!
      call_delegator_with_response
      nil
    else
      @url = request.URL if @follow_urls
      request
    end
  end

  def connection(connection, didFailWithError: error)
    log "HTTP Connection to #{@url.absoluteString} failed #{error.localizedDescription}"
    show_status_indicator false
    @request.done_loading!
    @response.error = error
    @response.error_message = error.localizedDescription
    call_delegator_with_response
  end

  def connection(connection, didSendBodyData:sending, totalBytesWritten:written, totalBytesExpectedToWrite:expected)
    if @upload_progress
      @upload_progress.call(sending, written, expected)
    end
  end

  def connectionDidFinishLoading(connection)
    show_status_indicator false
    @request.done_loading!
    response_body = NSData.dataWithData(@received_data) if @received_data
    @response.update(status_code: status_code, body: response_body, headers: response_headers, url: @url, original_url: @original_url)

    call_delegator_with_response
  end

  def connection(connection, didReceiveAuthenticationChallenge:challenge)
    if (challenge.previousFailureCount == 0)
      if credentials[:username].to_s.empty? && credentials[:password].to_s.empty?
        challenge.sender.continueWithoutCredentialForAuthenticationChallenge(challenge)
        log 'Continue without credentials to get 401 status in response'
      else
        new_credential = NSURLCredential.credentialWithUser(credentials[:username], password:credentials[:password], persistence:@credential_persistence)
        challenge.sender.useCredential(new_credential, forAuthenticationChallenge:challenge)
        log "auth challenged, answered with credentials: #{credentials.inspect}"
      end
    else
      did_receive_response(challenge.failureResponse)
      @response.update(status_code: status_code, headers: response_headers, url: @url, original_url: @original_url)
      challenge.sender.cancelAuthenticationChallenge(challenge)
      log 'Auth Failed :('
    end
  end

  def cancel
    @connection.cancel if @connection
    show_status_indicator false
    @request.done_loading!
  end

  private

  def did_receive_response(response)
    @status_code = response.statusCode
    @response_headers = response.allHeaderFields
    @response_size = response.expectedContentLength.to_f
  end

  def show_status_indicator(show)
    if App.ios?
      UIApplication.sharedApplication.networkActivityIndicatorVisible = show
    end
  end

  def create_request
    log "BubbleWrap::HTTP building a NSRequest for #{@url.description}"

    request = NSMutableURLRequest.requestWithURL(@url,
                                                  cachePolicy:@cache_policy,
                                                  timeoutInterval:@timeout)
    request.setHTTPMethod(@method)
    set_content_type
    append_auth_header
    request.setAllHTTPHeaderFields(@headers)
    request.setHTTPBody(@body)
    request.setHTTPShouldHandleCookies(@cookies)
    patch_nsurl_request(request)

    request
  end

  def set_content_type
    return if headers_provided?
    return if (@method == "GET" || @method == "HEAD" || @method == "OPTIONS")
    @headers ||= {}
    @headers["Content-Type"] = case @format
    when :json
      "application/json"
    when :xml
      "application/xml"
    when :text
      "text/plain"
    else
      if @format == :form_data || @payload_or_files_were_appended
        "multipart/form-data; boundary=#{@boundary}"
      else
        "application/x-www-form-urlencoded"
      end
    end
  end

  def headers_provided?
    @headers && @headers.keys.find {|k| k.downcase == 'content-type'}
  end

  def credentials_provided?
    @credentials[:username] && @credentials[:password]
  end

  def create_request_body
    return nil if (@method == "GET" || @method == "HEAD" || @method == "OPTIONS")
    return nil unless (@payload || @files)

    body = NSMutableData.data

    append_payload(body) if @payload
    append_files(body) if @files
    append_body_boundary(body) if @payload_or_files_were_appended

    log "Built HTTP body: \n #{body.to_str}"
    body
  end

  def append_payload(body)
    if @payload.is_a?(NSData)
      body.appendData(@payload)
    elsif @payload.is_a?(String)
      body.appendData(@payload.to_encoded_data @encoding)
    elsif @format == :json
      json_string = BW::JSON.generate(@payload)
      body.appendData(json_string.to_encoded_data @encoding)
    else
      append_form_params(body)
    end
    body
  end

  def append_form_params(body)
    list = process_payload_hash(@payload)
    list.each do |key, value|
      s = "--#{@boundary}\r\n"
      s += "Content-Disposition: form-data; name=\"#{key}\"\r\n\r\n"
      s += value.to_s
      s += "\r\n"
      body.appendData(s.to_encoded_data @encoding)
    end
    @payload_or_files_were_appended = true
    body
  end

  def append_auth_header
    return if @headers && @headers["Authorization"]

    if credentials_provided? && @present_credentials
      mock_request = CFHTTPMessageCreateRequest(nil, nil, nil, nil)
      CFHTTPMessageAddAuthentication(mock_request, nil, @credentials[:username], @credentials[:password], KCFHTTPAuthenticationSchemeBasic, false)

      @headers ||= {}
      @headers["Authorization"] = CFHTTPMessageCopyHeaderFieldValue(mock_request, "Authorization")
    end
  end

  def parse_file(key, value)
    value = {data: value} unless value.is_a?(Hash)
    raise(InvalidFileError, "You need to supply a `:data` entry in #{value} for file '#{key}' in your HTTP `:files`") if value[:data].nil?
    {
      data: value[:data],
      filename: value.fetch(:filename, key),
      content_type: value.fetch(:content_type, "application/octet-stream")
    }
  end

  def append_files(body)
    @files.each do |key, value|
      file = parse_file(key, value)
      s = "--#{@boundary}\r\n"
      s += "Content-Disposition: attachment; name=\"#{key}\"; filename=\"#{file[:filename]}\"\r\n"
      s += "Content-Type: #{file[:content_type]}\r\n\r\n"
      file_data = NSMutableData.new
      file_data.appendData(s.to_encoded_data @encoding)
      file_data.appendData(file[:data])
      file_data.appendData("\r\n".to_encoded_data @encoding)
      body.appendData(file_data)
    end
    @payload_or_files_were_appended = true
    body
  end

  def append_body_boundary(body)
    body.appendData("--#{@boundary}--\r\n".to_encoded_data @encoding)
  end

  def create_url(url_string)
    url_string = url_string.stringByAddingPercentEscapesUsingEncoding NSUTF8StringEncoding
    if (@method == "GET" || @method == "HEAD" || @method == "OPTIONS") && @payload
      unless @payload.empty?
        convert_payload_to_url if @payload.is_a?(Hash)
        url_string += "?#{@payload}"
      end
    end
    url = NSURL.URLWithString(url_string)

    validate_url(url)
    url
  end

  def validate_url(url)
    if !NSURLConnection.canHandleRequest(NSURLRequest.requestWithURL(url))
      raise InvalidURLError, "Invalid URL provided (Make sure you include a valid URL scheme, e.g. http:// or similar)."
    end
  end

  def escape(string)
    string_to_escape = string.to_s
    if string_to_escape
      CFURLCreateStringByAddingPercentEscapes nil, string_to_escape, nil, "!*'();:@&=+$,/?%#[]", KCFStringEncodingUTF8
    end
  end

  def convert_payload_to_url
    params_array = process_payload_hash(@payload)
    params_array.map! { |key, value| "#{escape key}=#{escape value}" }
    @payload = params_array.join("&")
  end

  def process_payload_hash(payload, prefix=nil)
    list = []
    payload.each do |k,v|
      if v.is_a?(Hash)
        new_prefix = prefix ? "#{prefix}[#{k.to_s}]" : k.to_s
        param = process_payload_hash(v, new_prefix)
        list += param
      elsif v.is_a?(Array)
        v.each do |val|
          param = prefix ? "#{prefix}[#{k.to_s}][]" : "#{k.to_s}[]"
          if val.is_a?(Hash)
            list += process_payload_hash(val, param)
          else
            list << [param, val]
          end
        end
      else
        param = prefix ? "#{prefix}[#{k.to_s}]" : k.to_s
        list << [param, v]
      end
    end
    list
  end

  def log(message)
    NSLog message if BubbleWrap.debug?
  end

  def escape_line_feeds(hash)
    return nil if hash.nil?
    escaped_hash = {}

    hash.each{|k,v| escaped_hash[k] = v.gsub("\n", CLRF) if v }
    escaped_hash
  end

  def patch_nsurl_request(request)
    request.instance_variable_set("@done_loading", false)

    def request.done_loading?; @done_loading; end
    def request.done_loading!; @done_loading = true; end
  end

  def call_delegator_with_response
    if @delegator && @delegator.respond_to?(:call)
      @delegator.call( @response, self )
    end
  end

  # This is a temporary method used for mocking.
  def create_connection(request, delegate)
    NSURLConnection.alloc.initWithRequest(request, delegate:delegate, startImmediately:false)
  end

end; end; end
