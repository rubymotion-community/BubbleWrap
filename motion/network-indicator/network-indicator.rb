module BubbleWrap
  module NetworkIndicator
    DELAY = 0.2

    module_function

    def show
      if Dispatch::Queue.current.to_s == 'com.apple.main-thread'
        self.counter += 1
        self.update_spinner
      else
        Dispatch::Queue.main.async do
          self.show
        end
      end
    end

    def hide
      if Dispatch::Queue.current.to_s == 'com.apple.main-thread'
        self.counter = [self.counter - 1, 0].max
        if self.counter == 0
          if @hide_indicator_timer
            @hide_indicator_timer.invalidate
          end
          @hide_indicator_timer = NSTimer.timerWithTimeInterval(DELAY - 0.01, target: self, selector: :update_spinner, userInfo: nil, repeats: false)
          NSRunLoop.mainRunLoop.addTimer(@hide_indicator_timer, forMode:NSRunLoopCommonModes)
        end
      else
        Dispatch::Queue.main.async do
          self.hide
        end
      end
    end

    def update_spinner
      if Dispatch::Queue.current.to_s == 'com.apple.main-thread'
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

    def counter
      @counter ||= 0
    end

    def counter=(value)
      @counter = value
    end

  end
end
