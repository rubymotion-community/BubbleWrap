# Provides a module to store global states
#
module BubbleWrap
  module App
    module_function

    # Returns the application's document directory path where users might be able to upload content.
    # @return [String] the path to the document directory
    def documents_path
      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]
    end

    # Returns the application resource path where resource located
    # @return [String] the application main bundle resource path
    def resources_path
      NSBundle.mainBundle.resourcePath
    end

    # Returns the default notification center
    # @return [NSNotificationCenter] the default notification center
    def notification_center
      NSNotificationCenter.defaultCenter
    end

    def user_cache
      NSUserDefaults.standardUserDefaults
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

    # Executes a block after a certain delay
    # Usage example:
    #   App.run_after(0.5) {  p "It's #{Time.now}"   }
    def run_after(delay,&block)
      NSTimer.scheduledTimerWithTimeInterval( delay,
                                              target: block,
                                              selector: "call:",
                                              userInfo: nil,
                                              repeats: false)
    end

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

    @states = {}

    def states
      @states
    end

    def name
      NSBundle.mainBundle.objectForInfoDictionaryKey 'CFBundleDisplayName'
    end

    def identifier
      NSBundle.mainBundle.bundleIdentifier
    end

    def version
      NSBundle.mainBundle.infoDictionary['CFBundleVersion']
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

    # @return [NSLocale] locale of user settings
    def current_locale
      languages = NSLocale.preferredLanguages
      if languages.count > 0
        return NSLocale.alloc.initWithLocaleIdentifier(languages.first)
      else
        return NSLocale.currentLocale
      end
    end

    # the current application environment : development, test, release
    def environment
      RUBYMOTION_ENV
    end

    def development?
      environment == 'development'
    end

    def test?
      environment == 'test'
    end

    def release?
      environment == 'release'
    end

  end
end
::App = BubbleWrap::App unless defined?(::App)
