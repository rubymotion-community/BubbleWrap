module BubbleWrap
  module Device
    module Screen

      module_function

      # Certifies that the device running the app has a Retina display
      # @return [TrueClass, FalseClass] true will be returned if the device has a Retina display, false otherwise.
      def retina?(screen=NSScreen.mainScreen)
        if screen.respondsToSelector('backingScaleFactor') && screen.backingScaleFactor == 2.0
          true
        else
          false
        end
      end
    end
  end
end
