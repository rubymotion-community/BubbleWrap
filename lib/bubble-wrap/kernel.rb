module Kernel
  
  # Verifies that the device running the app is an iPhone.
  # @return [TrueClass, FalseClass] true will be returned if the device is an iPhone, false otherwise.
  def iphone?
    UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone
  end

  # Verifies that the device running the app is an iPad.
  # @return [TrueClass, FalseClass] true will be returned if the device is an iPad, false otherwise.
  def ipad?
    UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad
  end

  # Certifies that the device running the app has a Retina display
  # @return [TrueClass, FalseClass] true will be returned if the device has a Retina display, false otherwise.
  def retina?
    if UIScreen.mainScreen.respondsToSelector('displayLinkWithTarget:selector:') && UIScreen.mainScreen.scale == 2.0
      true
    else
      false
    end
  end

  # Verifies that the device running has a front facing camera.
  # @return [TrueClass, FalseClass] true will be returned if the device has a front facing camera, false otherwise.
  def front_camera?
    UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDeviceFront)
  end

  # Verifies that the device running has a rear facing camera.
  # @return [TrueClass, FalseClass] true will be returned if the device has a rear facing camera, false otherwise.
  def rear_camera?
    UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDeviceRear)
  end

  # Returns the application's document directory path where users might be able to upload content.
  # @return [String] the path to the document directory
  def documents_path
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]
  end
  
  # Returns the application resource path where resource located
  # @return [String] the application main bundle resource path
  def resources_path
    NSBundle.mainBundle.resourcePath
  end

  # Returns the default notification center
  # @return [NSNotificationCenter] the default notification center
  def notification_center
    NSNotificationCenter.defaultCenter
  end

  def orientation
    case UIDevice.currentDevice.orientation
    when UIDeviceOrientationUnknown then :unknown
    when UIDeviceOrientationPortrait then :portrait
    when UIDeviceOrientationPortraitUpsideDown then :portrait_upside_down
    when UIDeviceOrientationLandscapeLeft then :landscape_left
    when UIDeviceOrientationLandscapeRight then :landscape_right
    when UIDeviceOrientationFaceUp then :face_up
    when UIDeviceOrientationFaceDown then :face_down
    else
      :unknown
    end
  end

  # @return [UIcolor]
  def rgb_color(r,g,b)
    rgba_color(r,g,b,1)
  end

  # @return [UIcolor]
  def rgba_color(r,g,b,a)
    UIColor.colorWithRed((r/255.0), green:(g/255.0), blue:(b/255.0), alpha:a)
  end

  def NSLocalizedString(key, value)
    NSBundle.mainBundle.localizedStringForKey(key, value:value, table:nil)
  end

  def user_cache
    NSUserDefaults.standardUserDefaults
  end

  def alert(msg)
    alert = UIAlertView.alloc.initWithTitle msg, 
                                              message: nil,
                                              delegate: nil, 
                                              cancelButtonTitle: "OK", 
                                              otherButtonTitles: nil
    alert.show
  end

  def simulator?
    @simulator_state ||= !(UIDevice.currentDevice.model =~ /simulator/i).nil?
  end

  # I had issues with #p on the device, this is a temporary workaround
  def p(arg)
    NSLog arg.inspect
  end

end
