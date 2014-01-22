describe BubbleWrap::Device::CameraWrapper do

  before do
    BW::Device.camera.instance_variable_set(:@front, nil)
    BW::Device.camera.instance_variable_set(:@rear, nil)
  end

  describe 'on device with only front facing camera' do
    before do
      UIImagePickerController.instance_eval do
        def isCameraDeviceAvailable(c)
          c == UIImagePickerControllerCameraDeviceFront
        end
        def isSourceTypeAvailable(c)
          c == UIImagePickerControllerSourceTypeCamera
        end
      end
    end

    describe '.front?' do
      it 'returns true' do
        BW::Device.camera.front?.should == true
      end
    end

    describe '.rear?' do
      it 'returns false' do
        BW::Device.camera.rear?.should == false
      end
    end

    describe '.physical_camera?' do
      it 'returns true' do
        BW::Device.camera.physical_camera?.should == true
      end
    end
  end

  describe 'on device with only rear facing camera' do
    before do
      UIImagePickerController.instance_eval do
        def isCameraDeviceAvailable(c)
          c == UIImagePickerControllerCameraDeviceRear
        end
        def isSourceTypeAvailable(c)
          c == UIImagePickerControllerSourceTypeCamera
        end
      end
    end

    describe '.front?' do
      it 'returns false' do
        BW::Device.camera.front?.should == false
      end
    end

    describe '.rear?' do
      it 'returns true' do
        BW::Device.camera.rear?.should == true
      end
    end

    describe '.physical_camera?' do
      it 'returns true' do
        BW::Device.camera.physical_camera?.should == true
      end
    end
  end

  describe 'on device with no physical camera' do
    before do
      UIImagePickerController.instance_eval do
        def isCameraDeviceAvailable(c)
          false
        end
        def isSourceTypeAvailable(c)
          false
        end
      end
    end

    describe '.front?' do
      it 'returns false' do
        BW::Device.camera.front?.should == false
      end
    end

    describe '.rear?' do
      it 'returns false' do
        BW::Device.camera.rear?.should == false
      end
    end

    describe '.physical_camera?' do
      it 'returns true' do
        BW::Device.camera.physical_camera?.should == false
      end
    end
  end
end
