describe BubbleWrap::App do
  describe '.documents_path' do
    it 'should end in "/Documents"' do
      App.documents_path[-10..-1].should == '/Documents'
    end
  end

  describe '.resources_path' do
    it 'should end in "/testSuite.app"' do
      if App.osx?
        App.resources_path.should =~ /\/testSuite(_spec)?.app\/Contents\/Resources$/
      else
        App.resources_path.should =~ /\/testSuite(_spec)?.app$/
      end
    end
  end

  describe '.notification_center' do
    it 'should be a NSNotificationCenter' do
      App.notification_center.should == NSNotificationCenter.defaultCenter
    end
  end

  describe '.user_cache' do
    it 'should be a NSUserDefaults' do
      App.user_cache.should == NSUserDefaults.standardUserDefaults
    end
  end

  describe '.states' do
    it 'returns a hash' do
      App.states.class.should == Hash
    end
    it "returns the real instance variable" do
      App.states.should == App.instance_variable_get(:@states)
    end
  end

  describe '.info_plist' do
    it 'returns the information property list hash' do
      App.info_plist.should == NSBundle.mainBundle.infoDictionary
    end
  end

  describe '.name' do
    it 'returns the application name' do
      App.name.should == 'testSuite'
    end
  end

  describe '.identifier' do
    it 'returns the application identifier' do
      App.identifier.should == 'io.bubblewrap.testSuite_spec'
    end
  end

  describe '.version' do
    it 'returns the application version' do
      App.version.should == '1.2.3'
    end
  end

  describe '.run_after' do
    class DelayedRunAfterTest; attr_accessor :test_value end

    it 'should run a block after the provided delay' do
      @test_obj = DelayedRunAfterTest.new

      App.run_after(0.1){ @test_obj.test_value = true }
      wait_for_change(@test_obj, 'test_value') do
        @test_obj.test_value.should == true
      end
    end

  end

  describe ".open_url" do

    it "uses NSURL or converts NSString in NSURL and opens it" do
      if Kernel.const_defined?(:UIApplication)
        application = UIApplication.sharedApplication
      else
        application = NSWorkspace.sharedWorkspace
      end
      def application.url; @url end
      def application.openURL(url); @url = url end

      url = NSURL.URLWithString('http://localhost')
      App.open_url(url)
      application.url.should.equal url

      url = 'http://localhost'
      App.open_url(url)
      application.url.class.should.equal NSURL
      application.url.description.should.equal url
    end

  end

  describe ".environment" do

    it 'returns current application environment' do
      App.environment.should.equal "test"
    end

  end

  describe ".test? .release? .development?" do

    it 'tests if current application environment is test' do
      App.test?.should.equal true
    end

    it 'tests if current application environment is release' do
      App.release?.should.equal false
    end

    it 'tests if current application environment is development' do
      App.development?.should.equal false
    end

  end

end
