module BubbleWrap
  module Device
    module_function

    # Shameless shorthand for accessing BubbleWrap::Screen
    def screen
      BubbleWrap::Device::Screen
    end

    # Delegates to BubbleWrap::Screen.retina?
    def retina?
      screen.retina?
    end
  end
end
