module BubbleWrap
  module NetworkIndicator
    DELAY = 0.2

    module_function

    def counter
      @counter ||= 0
    end

    def show
      if Dispatch::Queue.current.to_s == 'com.apple.main-thread'
        @counter = self.counter + 1
        self.update_spinner
      else
        Dispatch::Queue.main.async do
          self.show
        end
      end
    end

    def hide
      if Dispatch::Queue.current.to_s == 'com.apple.main-thread'
        @counter = [self.counter - 1, 0].max
        if self.counter == 0
          if @hide_indicator_timer
            @hide_indicator_timer.invalidate
          end
          @hide_indicator_timer = NSTimer.timerWithTimeInterval(DELAY - 0.01, target: self, selector: :update_spinner_timer, userInfo: nil, repeats: false)
          NSRunLoop.mainRunLoop.addTimer(@hide_indicator_timer, forMode:NSRunLoopCommonModes)
        end
      else
        Dispatch::Queue.main.async do
          self.hide
        end
      end
    end

    def update_spinner_timer
      update_spinner
    end

    def update_spinner
      if Dispatch::Queue.current.to_s == 'com.apple.main-thread'
        if @hide_indicator_timer
          @hide_indicator_timer.invalidate
          @hide_indicator_timer = nil
        end
        UIApplication.sharedApplication.networkActivityIndicatorVisible = (@counter > 0)
      else
        Dispatch::Queue.main.async do
          self.update_spinner
        end
      end
    end

    def visible?
      UIApplication.sharedApplication.networkActivityIndicatorVisible?
    end

    def reset!
      @counter = 0
      self.update_spinner
    end

  end
end
