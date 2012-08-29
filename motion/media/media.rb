module BubbleWrap
  module Media
    module_function

    def play_modal(*args, &block)
      Media::Player.new.retain.send(:play_modal, *args, &block)
    end

    def play(*args, &block)
      Media::Player.new.retain.send(:play, *args, &block)
    end
  end
end

::Media = BubbleWrap::Media unless defined?(::Media)