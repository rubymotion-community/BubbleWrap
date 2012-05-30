describe "HTTP" do
  
end


describe "HTTP::Response" do
  before do
    @response = BubbleWrap::HTTP::Response.new({ status_code: 200, url: 'http://localhost' })
  end

  it 'should turn the initialization Hash to instance variables' do
    @response.instance_variable_get(:@status_code).should == 200
    @response.instance_variable_get(:@url).should == 'http://localhost'
  end

  it "says OK only for status code 200" do
    @response.ok?.should.equal true
    BubbleWrap::HTTP::Response.new({status_code: 205}).ok?.should.not.equal true
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
    @query = BubbleWrap::HTTP::Query.new( 'http://localhost', :get, {})
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

  it "should set default timeout to 30s or the one from hash" do
    @query.instance_variable_get(:@timeout).should == 30
    
    new_query = BubbleWrap::HTTP::Query.new( 'http://localhost/', :get, {timeout: 10})
    new_query.instance_variable_get(:@timeout).should == 10
  end

  it "should create params with nested hashes with prefix[key]=value" do
    payload = { 
                user: { name: 'marin', surname: 'usalj' }, 
                twitter: '@mneorr',
                website: 'mneorr.com',
                values: [1, 2, 3]
    }
    expected_params = [
      'user[name]=marin', 
      'user[surname]=usalj', 
      'twitter=@mneorr',
      'website=mneorr.com',
      'values=[1, 2, 3]'
    ]
    @query.generate_get_params(payload).should.equal expected_params
  end

  it "should assign status_code, headers and response_size on didReceiveResponse:" do
    headers = { foo: 'bar' }
    status_code = 234
    length = 123.53

    response = FakeURLResponse.new(status_code, headers, length)
    @query.connection(nil, didReceiveResponse:response)

    @query.status_code.should.equal status_code
    @query.response_headers.should.equal headers
    @query.response_size.should.equal length
  end

  it "should initialize iVar and append the received data on didReceiveData:" do
    query_received_data.should.equal nil
    data = NSData.dataWithBytesNoCopy(Pointer.new(:char, 'abc'), length:24)
    
    @query.connection(nil, didReceiveData:nil)
    query_received_data.should.not.equal nil
    
    @query.connection(nil, didReceiveData:data)
    query_received_data.length.should.equal 24

    @query.connection(nil, didReceiveData:data)
    query_received_data.length.should.equal 48
  end

  def query_received_data
    @query.instance_variable_get(:@received_data)
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