module BubbleWrap
  module App
    module_function

    # Opens an url (string or instance of `NSURL`)
    # in the device's web browser.
    # Usage Example:
    #   App.open_url("http://matt.aimonetti.net")
    def open_url(url)
      unless url.is_a?(NSURL)
        url = NSURL.URLWithString(url)
      end
      UIApplication.sharedApplication.openURL(url)
    end

    # Displays a UIAlertView.
    #
    # title - The title as a String.
    # args  - The title of the cancel button as a String, or a Hash of options.
    #         (Default: { cancel_button_title: 'OK' })
    #         cancel_button_title - The title of the cancel button as a String.
    #         message             - The main message as a String.
    # block - Yields the alert object if a block is given, and does so before the alert is shown.
    def alert(title, *args, &block)
      options = { cancel_button_title: 'OK' }
      options.merge!(args.pop) if args.last.is_a?(Hash)

      if args.size > 0 && args.first.is_a?(String)
        options[:cancel_button_title] = args.shift
      end

      alert = UIAlertView.alloc.initWithTitle title,
        message: options[:message],
        delegate: nil,
        cancelButtonTitle: options[:cancel_button_title],
        otherButtonTitles: nil

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

    # the Application Window
    def window
      UIApplication.sharedApplication.keyWindow || UIApplication.sharedApplication.windows[0]
    end
  end
end