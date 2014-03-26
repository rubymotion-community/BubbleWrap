describe BubbleWrap::App do
  describe '.documents_path' do
    it 'should end in "/Documents"' do
      BubbleWrap::App.documents_path[-10..-1].should == '/Documents'
    end
  end

  describe '.resources_path' do
    it 'should end in "/testSuite.app"' do
      if BubbleWrap::App.osx?
        BubbleWrap::App.resources_path.should =~ /\/testSuite(_spec)?.app\/Contents\/Resources$/
      else
        BubbleWrap::App.resources_path.should =~ /\/testSuite(_spec)?.app$/
      end
    end
  end

  describe '.notification_center' do
    it 'should be a NSNotificationCenter' do
      BubbleWrap::App.notification_center.should == NSNotificationCenter.defaultCenter
    end
  end

  describe '.user_cache' do
    it 'should be a NSUserDefaults' do
      BubbleWrap::App.user_cache.should == NSUserDefaults.standardUserDefaults
    end
  end

  describe '.states' do
    it 'returns a hash' do
      BubbleWrap::App.states.class.should == Hash
    end
    it "returns the real instance variable" do
      BubbleWrap::App.states.should == BubbleWrap::App.instance_variable_get(:@states)
    end
  end

  describe '.info_plist' do
    it 'returns the information property list hash' do
      BubbleWrap::App.info_plist.should == NSBundle.mainBundle.infoDictionary
    end
  end

  describe '.name' do
    it 'returns the application name' do
      BubbleWrap::App.name.should == 'testSuite'
    end
  end

  describe '.identifier' do
    it 'returns the application identifier' do
      BubbleWrap::App.identifier.should == 'io.bubblewrap.testSuite_spec'
    end
  end

  describe '.version' do
    it 'returns the application version' do
      BubbleWrap::App.version.should == '1.2.3'
    end
  end

  describe '.run_after' do
    class DelayedRunAfterTest; attr_accessor :test_value end

    it 'should run a block after the provided delay' do
      @test_obj = DelayedRunAfterTest.new

      BubbleWrap::App.run_after(0.1){ @test_obj.test_value = true }
      wait_for_change(@test_obj, 'test_value') do
        @test_obj.test_value.should == true
      end
    end

  end

  describe ".environment" do

    it 'returns current application environment' do
      BubbleWrap::App.environment.should.equal "test"
    end

  end

  describe ".test? .release? .development?" do

    it 'tests if current application environment is test' do
      BubbleWrap::App.test?.should.equal true
    end

    it 'tests if current application environment is release' do
      BubbleWrap::App.release?.should.equal false
    end

    it 'tests if current application environment is development' do
      BubbleWrap::App.development?.should.equal false
    end

  end

end
