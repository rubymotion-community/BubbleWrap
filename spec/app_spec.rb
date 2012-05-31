describe BubbleWrap::App do
  describe '.documents_path' do
    it 'should end in "/Documents"' do
      BW::App.documents_path[-10..-1].should == '/Documents'
    end
  end

  describe '.resources_path' do 
    it 'should end in "/MotionLibTestSuite.app"' do
      BW::App.resources_path[-19..-1].should == '/testSuite_spec.app'
    end
  end

  describe '.notification_center' do
    it 'should be a NSNotificationCenter' do
      BW::App.notification_center.class.should == NSNotificationCenter
    end
  end

  describe '.user_cache' do
    it 'should be a NSUserDefaults' do
      BW::App.user_cache.class.should == NSUserDefaults
    end
  end

  describe '.alert' do
    before do
      @alert = BW::App.alert('1.21 Gigawatts!', 'Great Scott!')
    end

    after do
      @alert.removeFromSuperview
    end

    it 'returns an alert' do
      @alert.class.should == UIAlertView
    end

    it 'is displaying the correct title' do
      @alert.title.should == '1.21 Gigawatts!'
    end

    describe 'cancelButton' do
      it 'is present' do
        @alert.cancelButtonIndex.should == 0
      end

      it 'has the correct title' do
        @alert.buttonTitleAtIndex(@alert.cancelButtonIndex).should == 'Great Scott!'
      end
    end
  end

  describe '.states' do
    it 'returns a hash' do
      BW::App.states.class.should == Hash
    end
  end

  describe '.name' do
    it 'returns the application name' do
      BW::App.name.should == 'testSuite'
    end
  end

  describe '.identifier' do
    it 'returns the application identifier' do
      BW::App.identifier.should == 'io.bubblewrap.testSuite'
    end
  end

  describe '.frame' do
    it 'returns a CGRect' do
      BW::App.frame.class.should == CGRect
    end
  end

  describe '.delegate' do
    it 'returns a TestSuiteDelegate' do
      BW::App.delegate.class.should == TestSuiteDelegate
    end
  end
end
