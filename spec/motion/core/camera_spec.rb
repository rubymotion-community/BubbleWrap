def camera_picker
  BW::Camera.picker
end

describe BubbleWrap::Camera do
  before do
    @controller = UIViewController.alloc.init
  end

  describe '.picture' do
    it 'should have correct error for source_type camera' do
      BW::Camera.picture({source_type: :camera, media_types: [:image]}, @controller) do |result|
        result[:error].should == BW::Camera::Error::SOURCE_TYPE_NOT_AVAILABLE
        camera_picker.nil?.should == true
      end

      BW::Camera.picture({source_type: :saved_photos_album, media_types: [:image]}, @controller) do |result|
        result[:error].should == BW::Camera::Error::SOURCE_TYPE_NOT_AVAILABLE
      end
    end
  end

  describe '.imagePickerControllerDidCancel' do
    it 'should yield the correct error when canceled' do
      callback_ran = false

      BW::Camera.picture({source_type: :photo_library, media_types: [:image]}, @controller) do |result|
        result[:error].should == BW::Camera::Error::CANCELED
        callback_ran = true
      end

      BW::Camera.imagePickerControllerDidCancel(camera_picker)
      callback_ran.should == true
    end
  end

  describe '.imagePickerController:didFinishPickingMediaWithInfo:' do
    it 'should yield the correct results' do

      info = { UIImagePickerControllerMediaType => KUTTypeImage, 
                 UIImagePickerControllerOriginalImage => UIImage.alloc.init,
                 UIImagePickerControllerMediaURL => NSURL.alloc.init}
      callback_ran = false

      BW::Camera.picture({source_type: :photo_library, media_types: [:image]}, @controller) do |result|
        result[:error].nil?.should == true
        result.keys.should == [:media_type, :original_image, :media_url]
        result[:media_type].should == :image
        callback_ran = true
      end

      BW::Camera.imagePickerController(camera_picker, didFinishPickingMediaWithInfo: info)
      callback_ran.should == true
    end
  end
end
