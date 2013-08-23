describe BW::HTTP::QueryFactory do

  it "should be created using `BW::HTTP.query`" do
    BW::HTTP.query.should.is_a? BW::HTTP::QueryFactory
  end

  describe "should create query objects" do

    it "should create `get` request" do
      query = BW::HTTP.query.get("http://google.com")
      query.should.is_a?(BW::HTTP::Query)
      query.started?.should.equal false
      query.connection.was_started.should.equal false
    end

    it "should create `post` request" do
      query = BW::HTTP.query.post("http://google.com")
      query.should.is_a?(BW::HTTP::Query)
      query.started?.should.equal false
      query.connection.was_started.should.equal false
    end

    it "should create `put` request" do
      query = BW::HTTP.query.put("http://google.com")
      query.should.is_a?(BW::HTTP::Query)
      query.started?.should.equal false
      query.connection.was_started.should.equal false
    end

    it "should create `delete` request" do
      query = BW::HTTP.query.delete("http://google.com")
      query.should.is_a?(BW::HTTP::Query)
      query.started?.should.equal false
      query.connection.was_started.should.equal false
    end

    it "should create `head` request" do
      query = BW::HTTP.query.head("http://google.com")
      query.should.is_a?(BW::HTTP::Query)
      query.started?.should.equal false
      query.connection.was_started.should.equal false
    end

    it "should create `options` request" do
      query = BW::HTTP.query.options("http://google.com")
      query.should.is_a?(BW::HTTP::Query)
      query.started?.should.equal false
      query.connection.was_started.should.equal false
    end

    it "should create `patch` request" do
      query = BW::HTTP.query.patch("http://google.com")
      query.should.is_a?(BW::HTTP::Query)
      query.started?.should.equal false
      query.connection.was_started.should.equal false
    end

  end

end
