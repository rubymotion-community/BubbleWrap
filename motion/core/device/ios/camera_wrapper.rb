module BubbleWrap
  module Device
    module CameraWrapper

      module_function

      # The front-facing camera used to capture media
      # @return [Device::Camera, NilClass] a Camera will be returned if there is a front camera, nil otherwise
      def front
        @front ||= BubbleWrap::Device::Camera.front
      end

      # Verifies that the device running has a front facing camera.
      # @return [TrueClass, FalseClass] true will be returned if the device has a front facing camera, false otherwise.
      def front?
        !!front
      end

      # The rear-facing camera used to capture media
      # @return [Device::Camera, NilClass] a Camera will be returned if there is a rear camera, nil otherwise
      def rear
        @rear ||= BubbleWrap::Device::Camera.rear
      end

      # Verifies that the device running has a rear facing camera.
      # @return [TrueClass, FalseClass] true will be returned if the device has a rear facing camera, false otherwise.
      def rear?
        !!rear
      end

      # A Device::Camera used to capture media; by default it will use the :photo_library source type
      # See Device::Camera docs for more source type options.
      # @return [Device::Camera] a Camera will always be returned.
      def any
        @any ||= BubbleWrap::Device::Camera.any
      end
      # alias for any
      def photo_library
        any
      end

      # Should always return true, since picking images from *some* source is always possible
      # @return [TrueClass]
      def any?
        !!any
      end
    end
  end
end