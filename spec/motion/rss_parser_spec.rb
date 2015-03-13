describe "RSSParser" do
  extend WebStub::SpecHelpers

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
  end

  describe "parsing" do

    it "parses local file data" do
      parser = BW::RSSParser.new(File.read(@local_feed).to_data, true)
      episodes = []
      parser.parse { |episode| episodes << episode }
      episodes.length.should.equal 108
      episodes.last.title.should.equal 'Episode 001: Summer of Rails'
    end

    it "parses url data" do
      string = File.read(File.join(App.resources_path, 'atom.xml'))

      stub_request(:get, @feed_url).
        to_return(body: string, content_type: "application/xml")

      parser = BW::RSSParser.new(@feed_url)
      episodes = []
      parser.parse { |episode| episodes << episode }
      episodes.length.should.equal 108
      episodes.last.title.should.equal 'Episode 001: Summer of Rails'
    end

    it "handles errors" do
      error_url = 'http://doesnotexist.com'

      parser = BW::RSSParser.new(error_url)
      parser.parse
      wait 0.1 do
        parser.state.should.equal :errors
      end
    end
  end
end

