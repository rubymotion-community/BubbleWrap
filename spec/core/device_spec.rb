describe BubbleWrap::Device do

  describe 'on iPhone' do
    before do
      @idiom = UIUserInterfaceIdiomPhone
    end

    describe '.iphone?' do
      it 'returns true' do
        BW::Device.iphone?(@idiom).should == true
      end
    end

    describe '.ipad?' do
      it 'returns false' do
        BW::Device.ipad?(@idiom).should == false
      end
    end
  end

  describe 'on iPad' do
    before do
      @idiom = UIUserInterfaceIdiomPad
    end

    describe '.iphone?' do
      it 'returns false' do
        BW::Device.iphone?(@idiom).should == false
      end
    end

    describe '.ipad?' do
      it 'returns true' do
        BW::Device.ipad?(@idiom).should == true
      end
    end
  end

  describe 'on device with only front facing camera' do
    before do 
      @picker = Object.new.tap do |o|
        def o.isCameraDeviceAvailable(c)
          c == UIImagePickerControllerCameraDeviceFront
        end
        def o.method_missing(*args)
          UIImagePickerController.send(*args)
        end
      end
    end

    describe '.front_camera?' do
      it 'returns true' do
        BW::Device.front_camera?(@picker).should == true
      end
    end

    describe '.rear_camera?' do
      it 'returns false' do
        BW::Device.rear_camera?(@picker).should == false
      end
    end
  end

  describe 'on device with only rear facing camera' do
    before do 
      @picker = Object.new.tap do |o|
        def o.isCameraDeviceAvailable(c)
          c == UIImagePickerControllerCameraDeviceRear
        end
        def o.method_missing(*args)
          UIImagePickerController.send(*args)
        end
      end
    end

    describe '.front_camera?' do
      it 'returns false' do
        BW::Device.front_camera?(@picker).should == false
      end
    end

    describe '.rear_camera?' do
      it 'returns true' do
        BW::Device.rear_camera?(@picker).should == true
      end
    end
  end

  describe '.simulator?' do
    it 'returns true' do
      BW::Device.simulator?.should == true
    end
  end

  describe '.screen' do
    it 'return BubbleWrap::Screen' do
      BW::Device.screen.should == BW::Device::Screen
    end
  end

  describe '.retina?' do
    it 'delegates to BubbleWrap::Screen.retina?' do
      BW::Device.retina?.should == BW::Device::Screen.retina?
    end
  end

  describe '.orientation' do
    it 'delegates to BubbleWrap::Screen.orientation' do
      BW::Device.orientation.should == BW::Device::Screen.orientation
    end
  end
end
