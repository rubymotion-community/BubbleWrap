describe "HTTP" do

  before do
    @localhost_url = 'http://localhost'
    @fake_url = 'http://fake.url'
  end

  describe "Core HTTP method calls" do

    def test_http_method(method)
      called = false
      delegator = Proc.new { |r, q| @the_response = r; @the_query = q; called = true }
      query = BubbleWrap::HTTP.send(method, @localhost_url, { name: 'bubble-wrap', action: delegator })
      query.should.not.equal nil
      query.method.should.equal method.to_s.upcase
      query.options[:name].should.equal 'bubble-wrap'
      query.instance_variable_get(:@delegator).should.equal delegator

      query.connectionDidFinishLoading(query.connection)
      query.should.be.same_as @the_query
      query.response.should.be.same_as @the_response
      called.should.equal true
    end

    it ".get .post .put .delete .head .patch should properly generate the HTTP::Query" do
      [:get, :post, :put, :delete, :head, :patch].each do |method|
        test_http_method method
      end
    end

    it "uses the block instead of :action if both were given" do
      [:get, :post, :put, :delete, :head, :patch].each do |method|
        called = false
        expected_delegator = Proc.new {|response| called = true }

        query = BubbleWrap::HTTP.send(method, @localhost_url, { action: 'not_valid' }, &expected_delegator)
        query.connectionDidFinishLoading(query.connection)

        query.instance_variable_get(:@delegator).should.equal expected_delegator
        called.should.equal true
      end
    end

    it "works with classic blocks as well" do
      [:get, :post, :put, :delete, :head, :patch].each do |method|
        called = false
        query = BubbleWrap::HTTP.send(method, @localhost_url, { action: 'not_valid' } ) do |response|
          called = true
        end
        query.connectionDidFinishLoading(query.connection)
        called.should.equal true
      end
    end

  end


  describe "HTTP::Response" do
    before do
      @response = BubbleWrap::HTTP::Response.new({ status_code: 200, url: 'http://localhost' })
    end

    it 'should turn the initialization Hash to instance variables' do
      @response.instance_variable_get(:@status_code).should == 200
      @response.instance_variable_get(:@url).should == 'http://localhost'
    end

    it "says OK status code 20x" do
      @response.ok?.should.equal true
      (200..209).each do |code|
        BubbleWrap::HTTP::Response.new(status_code: code).ok?.should.be.true
      end
      [100..101, 300..307, 400..417, 500..505].inject([]){|codes, rg| codes += rg.to_a}.each do |code|
        BubbleWrap::HTTP::Response.new(status_code: code).ok?.should.be.false
      end
    end

    it "updates ivars when calling update" do
      @response.update(one: 'one', two: 'two')
      @response.instance_variable_get(:@one).should.equal 'one'
      @response.instance_variable_get(:@two).should.equal 'two'

      @response.update(one: 'three', two: 'four')
      @response.instance_variable_get(:@one).should.equal 'three'
      @response.instance_variable_get(:@two).should.equal 'four'
    end

    it "has appropriate attributes" do
      @response.should.respond_to :body
      @response.should.respond_to :headers
      @response.should.respond_to :url
      @response.should.respond_to :status_code=
      @response.should.respond_to :error_message=
    end

  end

  describe "HTTP::Query" do

    before do
      @credentials = { username: 'mneorr', password: '123456xx!@crazy' }
      @payload = {
        user: { name: 'marin', surname: 'usalj' },
        twitter: '@mneorr',
        website: 'mneorr.com',
        values: ['apple', 'orange', 'peach'],
        credentials: @credentials
      }
      @action = Proc.new { |response| @real_response = response; @delegator_was_called = true }
      @format = "application/x-www-form-urlencoded"
      @cache_policy = 24234
      @leftover_option = 'trololo'
      @headers = { 'User-Agent' => "Mozilla/5.0 (X11; Linux x86_64; rv:12.0) \n Gecko/20100101 Firefox/12.0" }
      @files = {
        fake_file: NSJSONSerialization.dataWithJSONObject({ fake: 'json' }, options:0, error:nil),
        empty_file: NSMutableData.data
      }
      @options = {
        action: @action,
        files: @files,
        payload: @payload,
        credentials: @credentials,
        headers: @headers,
        cache_policy: @cache_policy,
        leftover_option: @leftover_option,
        format: @format
      }
      @query = BubbleWrap::HTTP::Query.new( @localhost_url , :get, @options )
    end

    it "has appropriate attributes" do
      @query.should.respond_to :request=
      @query.should.respond_to :connection=
      @query.should.respond_to :credentials=
      @query.should.respond_to :proxy_credential=
      @query.should.respond_to :post_data=

      @query.should.respond_to :method
      @query.should.respond_to :response
      @query.should.respond_to :status_code
      @query.should.respond_to :response_headers
      @query.should.respond_to :response_size
      @query.should.respond_to :options
    end

    describe "When initialized" do

      it "should upcase the HTTP method" do
        @query.method.should.equal "GET"
      end

      it "throws an error for invalid/missing URL schemes" do
        %w(http https file ftp).each do |scheme|
          lambda {
            BW::HTTP::Query.new("#{scheme}://example.com", :get) { |r| p r.body.to_str }
          }.should.not.raise InvalidURLError
        end

        lambda {
          BW::HTTP::Query.new("bad://example.com", :get) { |r| p r.body.to_str }
        }.should.raise InvalidURLError
      end

      it "should set the deleted delegator from options" do
        @query.instance_variable_get(:@delegator).should.equal @action
        @options.should.not.has_key? :action
      end

      it "sets the files to instance variable" do
        @query.instance_variable_get(:@files).should.equal @files
        @options.should.not.has_key? :files
      end

      it "sets the format from options" do
        @query.instance_variable_get(:@format).should.equal @format
        @options.should.not.has_key? :format
      end

      it "should set self as the delegator if action was not passed in" do
        new_query = BubbleWrap::HTTP::Query.new( 'http://localhost', :get, {})
        new_query.instance_variable_get(:@delegator).should.equal new_query
      end

      it "should merge :username and :password in loaded credentials" do
        @query.credentials.should.equal @credentials

        options = { credentials: {} }
        new_query = BubbleWrap::HTTP::Query.new( @localhost_url, :get,  options)

        generated_credentials = {:username => '', :password => ''}
        new_query.credentials.should.equal generated_credentials
        options.should.be.empty
      end


      describe "PAYLOAD / UPLOAD FILES" do

        def create_query(payload, files)
          BubbleWrap::HTTP::Query.new( 'http://haha', :post, { payload: payload, files: files } )
        end

        def sample_data
          "twitter:@mneorr".dataUsingEncoding NSUTF8StringEncoding
        end

        it "should set payload from options{} to @payload" do
          payload = "user[name]=marin&user[surname]=usalj&twitter=@mneorr&website=mneorr.com&values[]=apple&values[]=orange&values[]=peach&credentials[username]=mneorr&credentials[password]=123456xx!@crazy"
          @query.instance_variable_get(:@payload).should.equal payload
          @options.should.not.has_key? :payload
        end

        it "should check if @payload is a hash before generating GET params" do
          query_string_payload = BubbleWrap::HTTP::Query.new( @fake_url , :get,  { payload: "name=apple&model=macbook"} )
          query_string_payload.instance_variable_get(:@payload).should.equal 'name=apple&model=macbook'
        end

        it "should check if payload is nil" do
          lambda{
            BubbleWrap::HTTP::Query.new( @fake_url , :post, {} )
          }.should.not.raise NoMethodError
        end

        it "should set the payload in URL only for GET and HEAD requests" do
          [:post, :put, :delete, :patch].each do |method|
            query = BubbleWrap::HTTP::Query.new( @localhost_url , method, { payload: @payload } )
            query.instance_variable_get(:@url).description.should.equal @localhost_url
          end

          payload = {name: 'marin'}
          [:get, :head].each do |method|
            query = BubbleWrap::HTTP::Query.new( @localhost_url , method, { payload: payload } )
            query.instance_variable_get(:@url).description.should.equal "#{@localhost_url}?name=marin"
          end
        end

        it "sets the HTTPBody DATA to @request for all methods except GET and HEAD" do
          payload = { name: 'apple', model: 'macbook'}
          files = { twitter: sample_data, site: "mneorr.com".dataUsingEncoding(NSUTF8StringEncoding) }

          puts "\n"
          [:post, :put, :delete, :patch].each do |method|
            puts "    - #{method}\n"
            query = BubbleWrap::HTTP::Query.new( @fake_url , method, { payload: payload, files: files } )
            uuid = query.instance_variable_get(:@boundary)
            real_payload = NSString.alloc.initWithData(query.request.HTTPBody, encoding:NSUTF8StringEncoding)
            real_payload.should.equal "--#{uuid}\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\napple\r\n--#{uuid}\r\nContent-Disposition: form-data; name=\"model\"\r\n\r\nmacbook\r\n--#{uuid}\r\nContent-Disposition: form-data; name=\"twitter\"; filename=\"twitter\"\r\nContent-Type: application/octet-stream\r\n\r\ntwitter:@mneorr\r\n--#{uuid}\r\nContent-Disposition: form-data; name=\"site\"; filename=\"site\"\r\nContent-Type: application/octet-stream\r\n\r\nmneorr.com\r\n--#{uuid}--\r\n"
          end

          [:get, :head].each do |method|
            puts "    - #{method}\n"
            query = BubbleWrap::HTTP::Query.new( @fake_url , method, { payload: payload } )
            real_payload = NSString.alloc.initWithData(query.request.HTTPBody, encoding:NSUTF8StringEncoding)
            real_payload.should.be.empty
          end
        end

        it "sets the payload without conversion to-from NSString if the payload was NSData" do
          data = sample_data
          lambda { query = create_query(data, nil) }.should.not.raise NoMethodError
        end

        it "sets the payload as a string if JSON" do
          json = "{\"foo\":42,\"bar\":\"BubbleWrap\"}"
          puts "\n"
          [:put, :post, :delete, :patch].each do |method|
            puts "    - #{method}\n"
            query = BubbleWrap::HTTP::Query.new( @fake_url , method, { payload: json } )
            set_payload = NSString.alloc.initWithData(query.request.HTTPBody, encoding:NSUTF8StringEncoding)
            set_payload.should.equal json
          end
        end

        it "sets the payload for a nested hash to multiple form-data parts" do
          payload = { computer: { name: 'apple', model: 'macbook'} }
          query = BubbleWrap::HTTP::Query.new( @fake_url, :post, { payload: payload } )
          uuid = query.instance_variable_get(:@boundary)
          real_payload = NSString.alloc.initWithData(query.request.HTTPBody, encoding:NSUTF8StringEncoding)
          real_payload.should.equal "--#{uuid}\r\nContent-Disposition: form-data; name=\"computer[name]\"\r\n\r\napple\r\n--#{uuid}\r\nContent-Disposition: form-data; name=\"computer[model]\"\r\n\r\nmacbook\r\n--#{uuid}--\r\n"
        end

      end

      it "should set default timeout to 30s or the one from hash" do
        @query.instance_variable_get(:@timeout).should == 30

        options = {timeout: 10}
        new_query = BubbleWrap::HTTP::Query.new( @localhost_url, :get, options)

        new_query.instance_variable_get(:@timeout).should == 10
        options.should.be.empty
      end

      it "should delete :headers from options and escape Line Feeds" do
        escaped_lf = {"User-Agent"=>"Mozilla/5.0 (X11; Linux x86_64; rv:12.0) \r\n Gecko/20100101 Firefox/12.0"}
        @query.instance_variable_get(:@headers).should.equal escaped_lf
      end

      it "should delete :cache_policy or set NSURLRequestUseProtocolCachePolicy" do
        @query.instance_variable_get(:@cache_policy).should.equal @cache_policy
        @options.should.not.has_key? :cache_policy

        new_query = BubbleWrap::HTTP::Query.new( @localhost_url, :get, {})
        new_query.instance_variable_get(:@cache_policy).should.equal NSURLRequestUseProtocolCachePolicy
      end

      it "should set the rest of options{} to ivar @options" do
        @query.options.size.should.equal 1
        @query.options.values[0].should.equal @leftover_option
      end

      it "should create a new response before instantiating a new request" do
        @query.response.should.not.equal nil
      end

      it "should call initiate_request with the URL passed in" do
        processed_url = "http://localhost?user%5Bname%5D=marin&user%5Bsurname%5D=usalj&twitter=@mneorr&website=mneorr.com&values%5B%5D=apple&values%5B%5D=orange&values%5B%5D=peach&credentials%5Busername%5D=mneorr&credentials%5Bpassword%5D=123456xx!@crazy"
        @query.instance_variable_get(:@url).description.should.equal processed_url
      end

      it "should pass the new request in the new connection" do
        @query.connection.request.URL.description.should.equal @query.request.URL.description
      end

      it "should start the connection" do
        @query.connection.was_started.should.equal true
      end

      it "should turn on the network indicator" do
        UIApplication.sharedApplication.isNetworkActivityIndicatorVisible.should.equal true
      end

    end

    describe "create request" do

      before do
        @url_string = 'http://initiated-request.dev/to convert'
        @headers = { fake: 'headers' }
        @get_query = BubbleWrap::HTTP::Query.new( @url_string , :get,  { headers: @headers } )
      end

      it "should create a new request with HTTP method & header fields" do
        @query.request.HTTPMethod.should.equal @query.method
        @get_query.request.allHTTPHeaderFields.should.equal @headers
      end

      it "creates a new NSURLConnection and sets itself as a delegate" do
        @query.connection.delegate.should.equal @query
      end

      it "should patch the NSURLRequest with done_loading and done_loading!" do
        @query.request.done_loading?.should.equal @query.request.instance_variable_get(:@done_loading)

        @query.request.instance_variable_set(:@done_loading, false)
        @query.request.done_loading?.should.equal false
        @query.request.done_loading!
        @query.request.done_loading?.should.equal true
      end

      it "should pass the right arguments when creating new request" do
        @query.request.cachePolicy.should.equal @query.instance_variable_get(:@cache_policy)
        @query.request.timeoutInterval.should.equal @query.instance_variable_get(:@timeout)
      end

    end

    describe "create POST request" do

      before do
        @url_string = 'http://initiated-request.dev/post'
        @headers = { fake: 'headers' }
        @payload = { key:'abc1234' }
        @post_query = BubbleWrap::HTTP::Query.new(@url_string, :post, {headers: @headers, payload: @payload})
      end

      it "should add default Content Type if no payload is given" do
        query_without_payload = BubbleWrap::HTTP::Query.new(@url_string, :post, {headers: @headers})
        query_without_payload.request.allHTTPHeaderFields.should.include? 'Content-Type'
      end

      it "should automatically provide Content-Type if a payload is provided" do
        @post_query.request.allHTTPHeaderFields.should.include?('Content-Type')
      end

      it "should use the format parameter to decide the Content-Type" do
        json_query = BubbleWrap::HTTP::Query.new(@url_string, :post, {headers: @headers, format: :json, payload: "{\"key\":\"abc1234\"}"})
        json_query.request.allHTTPHeaderFields['Content-Type'].should.equal "application/json"
      end

      it "should default to multipart/form-data for payloads with a hash" do
        uuid = @post_query.instance_variable_get(:@boundary)
        @post_query.request.allHTTPHeaderFields['Content-Type'].should.equal "multipart/form-data; boundary=#{uuid}"
      end

      it "should default to application/x-www-form-urlencoded for non-hash payloads" do
        string_query = BubbleWrap::HTTP::Query.new(@url_string, :post, {headers: @headers, payload: "{\"key\":\"abc1234\"}"})
        string_query.request.allHTTPHeaderFields['Content-Type'].should.equal "application/x-www-form-urlencoded"
      end

      it "should not add Content-Type if you provide one yourself" do
        # also ensures check is case insenstive
        @headers = { fake: 'headers', 'CONTENT-TYPE' => 'x-banana' }
        @post_query = BubbleWrap::HTTP::Query.new(@url_string, :post, {headers: @headers, payload: @payload})
        @post_query.request.allHTTPHeaderFields['CONTENT-TYPE'].should.equal @headers['CONTENT-TYPE']
      end

    end

    describe "Generating payloads" do

      it "should create payload key/value pairs from nested hashes with prefix[key]=value" do
        expected_params = [
          ['user[name]', 'marin'],
          ['user[surname]', 'usalj'],
          ['twitter', '@mneorr'],
          ['website', 'mneorr.com'],
          ['values[]', 'apple'],
          ['values[]', 'orange'],
          ['values[]', 'peach'],
          ['credentials[username]', 'mneorr'],
          ['credentials[password]', '123456xx!@crazy']
        ]
        @query.send(:process_payload_hash, @payload).should.equal expected_params
      end

    end

    describe "when didReceiveResponse:" do

      it "should assign status_code, headers and response_size" do
        headers = { foo: 'bar' }
        status_code = 234
        length = 123.53

        response = FakeURLResponse.new(status_code, headers, length)
        @query.connection(nil, didReceiveResponse:response)

        @query.status_code.should.equal status_code
        @query.response_headers.should.equal headers
        @query.response_size.should.equal length
      end

    end

    describe "when didRecieveData:" do

      def query_received_data
        @query.instance_variable_get(:@received_data)
      end

      it "should initialize @received_data and append the received data" do
        query_received_data.should.equal nil
        data = NSData.dataWithBytesNoCopy(Pointer.new(:char, 'abc'), length:24)

        @query.connection(nil, didReceiveData:nil)
        query_received_data.should.not.equal nil

        @query.connection(nil, didReceiveData:data)
        query_received_data.length.should.equal 24

        @query.connection(nil, didReceiveData:data)
        query_received_data.length.should.equal 48
      end

    end



    describe "when requestDidFailWithError:" do
      before do
        @fake_error = NSError.errorWithDomain('testing', code:7768, userInfo:nil)
      end

      it "should turn off network indicator" do
        UIApplication.sharedApplication.isNetworkActivityIndicatorVisible.should == true
        @query.connection(nil, didFailWithError:@fake_error)
        UIApplication.sharedApplication.isNetworkActivityIndicatorVisible.should == false
      end

      it "should set request_done to true" do
        @query.request.done_loading?.should == false
        @query.connection(nil, didFailWithError:@fake_error)
        @query.request.done_loading?.should == true
      end

      it "should set the error message to response object" do
        @query.response.error_message.should.equal nil
        @query.connection(nil, didFailWithError:@fake_error)
        @query.response.error_message.should.equal @fake_error.localizedDescription
      end

      it "should check if there's a callback block and pass the response in" do
        expected_response = BubbleWrap::HTTP::Response.new
        real_response = nil
        block = lambda{ |response, query| real_response = response }

        query = BubbleWrap::HTTP::Query.new(@localhost_url, :get, { :action => block })
        query.instance_variable_set(:@response, expected_response)

        query.connection(nil, didFailWithError:@fake_error)
        real_response.should.equal expected_response
      end

    end

    describe "when connectionDidFinishLoading:" do

      it "should turn off the network indicator" do
        UIApplication.sharedApplication.isNetworkActivityIndicatorVisible.should == true

        @query.connectionDidFinishLoading(nil)
        UIApplication.sharedApplication.isNetworkActivityIndicatorVisible.should == false
      end

      it "should set request_done to true" do
        @query.request.done_loading?.should == false

        @query.connectionDidFinishLoading(nil)
        @query.request.done_loading?.should == true
      end

      it "should set response_body to @received data if not nil" do
        data = NSData.dataWithBytesNoCopy(Pointer.new(:char, 'abc'), length:24)
        headers = { foo: 'bar' }
        status_code = 234
        response = FakeURLResponse.new(status_code, headers, 65456)

        @query.connection(nil, didReceiveResponse:response)
        @query.connection(nil, didReceiveData:data)
        @query.connectionDidFinishLoading(nil)

        @query.response.body.should.equal data
        @query.response.status_code.should.equal status_code
        @query.response.headers.should.equal headers
        @query.response.url.should.equal @query.instance_variable_get(:@url)
      end

      it "should check if there's a callback block and pass the response in" do
        expected_response = BubbleWrap::HTTP::Response.new
        real_response = nil
        block = lambda{ |response, query| real_response = response }
        query = BubbleWrap::HTTP::Query.new(@localhost_url, :get, { :action => block })
        query.instance_variable_set(:@response, expected_response)

        query.connectionDidFinishLoading(nil)
        real_response.should.equal expected_response
      end

    end

    describe "when connection:willSendRequest:redirectResponse:" do
      before do
        @request = NSMutableURLRequest.requestWithURL NSURL.URLWithString('http://fakehost.local/')
      end

      it "should forward the new request for 30 times/redirections" do
        1.upto(35) do |numbah|
          request = @query.connection(nil, willSendRequest:@request, redirectResponse:nil)
          request.should.equal numbah < 30 ? @request : nil
        end
      end

      describe "after 30 redirects" do
        before do
          31.times do
            @query.connection(nil, willSendRequest:@request, redirectResponse:nil)
          end
        end

        it "sets the error message on response" do
          @real_response.error_message.should.equal "Too many redirections"
        end

        it "sets the request.done_loading" do
          @query.request.done_loading?.should.equal true
        end

        it "calls the delegator block" do
          @delegator_was_called.should.equal true
        end
      end

    end

    describe "didReceiveAuthenticationChallenge" do
      before do
        @challenge = FakeChallenge.new
        @challenge.previousFailureCount = 0
        @query.connection(nil, didReceiveAuthenticationChallenge:@challenge)
      end

      it "should cancel the authentication if the failure count was not 0" do
        @challenge.previousFailureCount = 1
        @query.connection(nil, didReceiveAuthenticationChallenge:@challenge)
        @challenge.sender.was_cancelled.should.equal true
      end

      it "should pass in Credentials and the challenge itself to the sender" do
        @challenge.sender.challenge.should.equal @challenge
        @challenge.sender.credential.user.should.equal @credentials[:username]
        @challenge.sender.credential.password.should.equal @credentials[:password]
      end

      it "always uses NSURLCredentialPersistenceForSession" do
        @challenge.sender.credential.persistence.should.equal NSURLCredentialPersistenceForSession
      end

    end

    class FakeSender
      attr_reader :challenge, :credential, :was_cancelled
      def cancelAuthenticationChallenge(challenge)
        @was_cancelled = true
      end
      def useCredential(credential, forAuthenticationChallenge:challenge)
        @challenge = challenge
        @credential = credential
      end
    end

    class FakeChallenge
      attr_accessor :previousFailureCount

      def sender
        @fake_sender ||= FakeSender.new
      end
    end

    class BubbleWrap::HTTP::Query
      def create_connection(request, delegate); FakeURLConnection.new(request, delegate); end
    end

    class FakeURLConnection < NSURLConnection
      attr_reader :delegate, :request, :was_started
      def initialize(request, delegate)
        @request = request
        @delegate = delegate
        self.class.connectionWithRequest(request, delegate:delegate)
      end
      def start
        @was_started = true
        super
      end
    end

    class FakeURLResponse
      attr_reader :statusCode, :allHeaderFields, :expectedContentLength
      def initialize(status_code, headers, length)
        @statusCode = status_code
        @allHeaderFields = headers
        @expectedContentLength = length
      end
    end

  end

end
