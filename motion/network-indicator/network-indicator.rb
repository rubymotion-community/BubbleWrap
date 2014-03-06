module BubbleWrap
  module NetworkIndicator

    module_function

    def show
      self.counter += 1
      UIApplication.sharedApplication.networkActivityIndicatorVisible = true
    end

    def hide
      self.counter = [self.counter - 1, 0].max
      if self.counter == 0
        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
      end
    end

    def visible?
      UIApplication.sharedApplication.networkActivityIndicatorVisible?
    end

    def reset!
      @counter = 0
      UIApplication.sharedApplication.networkActivityIndicatorVisible = false
    end

    def counter
      @counter ||= 0
    end

    def counter=(value)
      @counter = value
    end

  end
end
