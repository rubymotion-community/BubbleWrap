describe BubbleWrap::HTTP::Response do

  before do
    @response = BubbleWrap::HTTP::Response.new({ status_code: 200, url: 'http://localhost' })
  end

  it 'should turn the initialization Hash to instance variables' do
    @response.instance_variable_get(:@status_code).should == 200
    @response.instance_variable_get(:@url).should == 'http://localhost'
  end

  it "says OK status code 2xx" do
    @response.ok?.should.equal true
    (200..211).each do |code|
      BubbleWrap::HTTP::Response.new(status_code: code).ok?.should.be.true
    end
    [100..101, 300..307, 400..417, 500..505].inject([]){|codes, rg| codes += rg.to_a}.each do |code|
      BubbleWrap::HTTP::Response.new(status_code: code).ok?.should.be.false
    end
  end

  it "updates the status description" do
    @response.status_description.should.equal 'no error'
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
    @response.should.respond_to :error_code=
  end

end
