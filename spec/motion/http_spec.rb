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

end
