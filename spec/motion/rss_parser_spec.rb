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
      parser = BW::RSSParser.new(@feed_url)
      episodes = []
      parser.parse { |episode| episodes << episode }
      episodes.length.should.equal 108
      episodes.last.title.should.equal 'Episode 001: Summer of Rails'
    end

    it "handles errors" do
      parser = BW::RSSParser.new("http://doesnotexist.com")
      parser.parse
      parser.state.should.equal :errors
    end

    module BW
      module HTTP
        class << self
          # To avoid interfering the http_spec's mocking, we only want to override HTTP.get if it's
          # for the RSSParser spec.
          alias_method :original_get, :get
          def get(url, options={}, &block)
            if url == 'https://raw.github.com/gist/2952427/9f1522cbe5d77a72c7c96c4fdb4b77bd58d7681e/atom.xml'
              string = File.read(File.join(App.resources_path, 'atom.xml'))
              yield BW::HTTP::Response.new(body: string.to_data, status_code: 200)
            elsif url == 'http://doesnotexist.com'
              yield BW::HTTP::Response.new(status_code: nil)
            else
              original_get(url, options, &block)
            end
          end
        end
      end
    end
  end
end

