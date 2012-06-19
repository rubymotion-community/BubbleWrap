describe "RSSParser" do

  before do
    @feed_url = 'https://raw.github.com/gist/2952427/9f1522cbe5d77a72c7c96c4fdb4b77bd58d7681e/atom.xml'
    @ns_url = NSURL.alloc.initWithString(@feed_url)
    @local_feed = File.join(App.resources_path, 'atom.xml')
  end

  describe "initialization" do

    it "works with a string representing an url" do
      parser = BW::RSSParser.new(@feed_url)
      parser.source.class.should.equal NSURL
      parser.source.absoluteString.should.equal @feed_url
    end

    it "works with a NSURL instance" do
      parser = BW::RSSParser.new(@ns_url)
      parser.source.class.should.equal NSURL
      parser.source.absoluteString.should.equal @feed_url
    end

    it "works with some data" do
      # feed_data_string = File.read(@local_feed)
      # parser = BW::RSSParser.new(feed_data_string, true)
      # parser.source.class.should.equal NSData
      # parser.source.to_str.should.equal @feed_data_string
      # parser = BW::RSSParser.new(@feed_data_string.to_data, true)
      # parser.source.class.should.equal NSURL
      # parser.source.class.should.equal NSData
      # parser.source.to_str.should.equal @feed_data_string
    end
  end

end

