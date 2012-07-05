def camera_picker
  @camera.instance_variable_get("@picker")
end

def example_info
  info = { UIImagePickerControllerMediaType => KUTTypeImage,
                 UIImagePickerControllerOriginalImage => UIImage.alloc.init,
                 UIImagePickerControllerMediaURL => NSURL.alloc.init}
end

describe BubbleWrap::Device::Camera do
  before do
    @controller = UIViewController.alloc.init
    @controller.instance_eval do
      def presentViewController(*args)
        true
      end
    end
    @camera = BW::Device::Camera.new
  end

  describe '.flash?' do
    before do
      UIImagePickerController.instance_eval do
        def self.isCameraDeviceAvailable(c)
          return true
        end

        def self.isFlashAvailableForCameraDevice(c)
          return c == UIImagePickerControllerCameraDeviceFront
        end
      end
    end

    it 'should be true for front cameras' do
      BW::Device::Camera.front.flash?.should == true
    end

    it 'should be false for rear cameras' do
      BW::Device::Camera.rear.flash?.should == false
    end
  end

  describe '.picture' do
    it 'should have correct error for source_type camera' do
      @camera.picture({source_type: :camera, media_types: [:image]}, @controller) do |result|
        result[:error].should == BW::Camera::Error::SOURCE_TYPE_NOT_AVAILABLE
        camera_picker.nil?.should == true
      end

      @camera.picture({source_type: :saved_photos_album, media_types: [:image]}, @controller) do |result|
        result[:error].should == BW::Camera::Error::SOURCE_TYPE_NOT_AVAILABLE
      end
    end

    describe 'under normal conditions' do
      before do
        class FakePickerClass
          def self.isCameraDeviceAvailable(c)
            c == UIImagePickerControllerCameraDeviceFront
          end

          def self.isSourceTypeAvailable(c)
            c == UIImagePickerControllerSourceTypeCamera
          end

          def self.availableMediaTypesForSourceType(c)
            [KUTTypeMovie, KUTTypeImage]
          end

          def dismissViewControllerAnimated(*args)
            true
          end

          def self.method_missing(*args)
            UIImagePickerController.send(*args)
          end
        end
        @picker_klass = FakePickerClass
      end

      it 'should work' do
        camera = BW::Device.camera.front
        camera.instance_variable_set("@picker_klass", @picker_klass)
        image_view = nil
        info = example_info

        camera.picture(media_types: [:movie, :image]) do |result|
          image_view = UIImageView.alloc.initWithImage(result[:original_image])
        end

        camera.picker
        camera.imagePickerController(camera.instance_variable_get("@picker"), didFinishPickingMediaWithInfo: info)
        image_view.nil?.should == false
      end
    end
  end

  describe '.imagePickerControllerDidCancel' do
    it 'should yield the correct error when canceled' do
      callback_ran = false

      @camera.picture({source_type: :photo_library, media_types: [:image]}, @controller) do |result|
        result[:error].should == BW::Camera::Error::CANCELED
        callback_ran = true
      end

      @camera.imagePickerControllerDidCancel(camera_picker)
      callback_ran.should == true
    end
  end

  describe '.imagePickerController:didFinishPickingMediaWithInfo:' do
    it 'should yield the correct results' do

      info = example_info
      callback_ran = false

      @camera.picture({source_type: :photo_library, media_types: [:image]}, @controller) do |result|
        result[:error].nil?.should == true
        result.keys.should == [:media_type, :original_image, :media_url]
        result[:media_type].should == :image
        callback_ran = true
      end

      @camera.imagePickerController(camera_picker, didFinishPickingMediaWithInfo: info)
      callback_ran.should == true
    end
  end
end
