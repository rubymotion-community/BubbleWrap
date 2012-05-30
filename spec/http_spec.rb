describe "Response" do
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
  
  it "should respond to apropriate attributes" do
    @response.should.respond_to :body
    @response.should.respond_to :headers
    @response.should.respond_to :status_code
    @response.should.respond_to :error_message
    @response.should.respond_to :url
  end

  it "should have settable error_message and status_code" do
    @response.should.respond_to :status_code=
    @response.should.respond_to :error_message=
  end
  
end