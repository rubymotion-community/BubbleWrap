describe BubbleWrap::App do
  describe "OS X" do

    describe ".open_url" do
      it "uses NSURL or converts NSString in NSURL and opens it" do
        workspace = NSWorkspace.sharedWorkspace
        def workspace.url; @url end
        def workspace.openURL(url); @url = url end

        url = NSURL.URLWithString('http://localhost')
        App.open_url(url)
        workspace.url.should.equal url

        url = 'http://localhost'
        App.open_url(url)
        workspace.url.class.should.equal NSURL
        workspace.url.description.should.equal url
      end
    end

    describe '.delegate' do
      it 'returns a TestSuiteDelegate' do
        App.delegate.should == NSApplication.sharedApplication.delegate
      end
    end

    describe '.shared' do
      it 'returns UIApplication.sharedApplication' do
        App.shared.should == NSApplication.sharedApplication
      end
    end
  end
end
