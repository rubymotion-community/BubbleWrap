module BubbleWrap
  module App
    module_function

    # Opens an url (string or instance of `NSURL`)
    # in the device's web browser or in the correspondent app for custom schemas
    # Usage Example:
    #   App.open_url("http://matt.aimonetti.net")
    #   App.open_url("fb://profile")
    def open_url(url)
      unless url.is_a?(NSURL)
        url = NSURL.URLWithString(url)
      end
      UIApplication.sharedApplication.openURL(url)
    end

    # Returns whether an app can open a given URL resource (string or instance of `NSURL`)
    # Useful to check if certain apps are installed before calling to their custom schemas.
    # Usage Example:
    #   App.open_url("fb://profile") if App.can_open_url("fb://")
    def can_open_url(url)
      unless url.is_a?(NSURL)
        url = NSURL.URLWithString(url)
      end
      UIApplication.sharedApplication.canOpenURL(url)
    end

    # Displays a UIAlertView.
    #
    # title - The title as a String.
    # args  - The title of the cancel button as a String, or a Hash of options.
    #         (Default: { cancel_button_title: 'OK' })
    #         cancel_button_title - The title of the cancel button as a String.
    #         message             - The main message as a String.
    # block - Yields the alert object if a block is given, and does so before the alert is shown.
    #
    # Returns an instance of BW::UIAlertView
    def alert(title, *args, &block)
      options = { cancel_button_title: 'OK' }
      options.merge!(args.pop) if args.last.is_a?(Hash)

      if args.size > 0 && args.first.is_a?(String)
        options[:cancel_button_title] = args.shift
      end

      options[:title]               = title
      options[:buttons]             = options[:cancel_button_title]
      options[:cancel_button_index] = 0 # FIXME: alerts don't have "Cancel" buttons

      alert = UIAlertView.default(options)

      yield(alert) if block_given?

      alert.show
      alert
    end

    # Return application frame
    def frame
      UIScreen.mainScreen.applicationFrame
    end

    # Main Screen bounds. Useful when starting the app
    def bounds
      UIScreen.mainScreen.bounds
    end

    # Application Delegate
    def delegate
      UIApplication.sharedApplication.delegate
    end

    # the Application object.
    def shared
      UIApplication.sharedApplication
    end

    def windows
      UIApplication.sharedApplication.windows
    end

    # the Application Window
    def window
      normal_windows = App.windows.select { |w|
        w.windowLevel == UIWindowLevelNormal
      }

      key_window = normal_windows.select {|w|
        w == UIApplication.sharedApplication.keyWindow
      }.first

      key_window || normal_windows.first
    end
  end
end
