module BubbleWrap
  module Device
    module_function

    # Verifies that the device running the app is an iPhone.
    # @return [TrueClass, FalseClass] true will be returned if the device is an iPhone, false otherwise.
    def iphone?(idiom=UIDevice.currentDevice.userInterfaceIdiom)
      idiom == UIUserInterfaceIdiomPhone
    end

    # Verifies that the device running the app is an iPad.
    # @return [TrueClass, FalseClass] true will be returned if the device is an iPad, false otherwise.
    def ipad?(idiom=UIDevice.currentDevice.userInterfaceIdiom)
      idiom == UIUserInterfaceIdiomPad
    end

    # A camera used to capture media
    # @return [Device::Camera, NilClass] a Camera will be returned if there is a front camera, nil otherwise
    def front_camera
      BubbleWrap::Device::Camera.front
    end

    # Verifies that the device running has a front facing camera.
    # @return [TrueClass, FalseClass] true will be returned if the device has a front facing camera, false otherwise.
    def front_camera?
      !!self.front_camera
    end

    # A camera used to capture media
    # @return [Device::Camera, NilClass] a Camera will be returned if there is a rear camera, nil otherwise
    def rear_camera
      BubbleWrap::Device::Camera.rear
    end

    # Verifies that the device running has a rear facing camera.
    # @return [TrueClass, FalseClass] true will be returned if the device has a rear facing camera, false otherwise.
    def rear_camera?
      !!self.rear_camera
    end

    def simulator?
      @simulator_state ||= !(UIDevice.currentDevice.model =~ /simulator/i).nil?
    end

    # Shameless shorthand for accessing BubbleWrap::Screen
    def screen
      BubbleWrap::Device::Screen
    end

    # Delegates to BubbleWrap::Screen.retina?
    def retina?
      screen.retina?
    end

    # Delegates to BubbleWrap::Screen.orientation
    def orientation
      screen.orientation
    end

  end
end
::Device = BubbleWrap::Device
