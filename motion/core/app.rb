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

    def alert(msg,cancelButtonTitle='OK')
      alert = UIAlertView.alloc.initWithTitle msg, 
        message: nil,
        delegate: nil, 
        cancelButtonTitle: cancelButtonTitle,
        otherButtonTitles: nil
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

    # @return [NSLocale] locale of user settings
    def current_locale
      languages = NSLocale.preferredLanguages
      if languages.count > 0
        return NSLocale.alloc.initWithLocaleIdentifier(languages.first)
      else
        return NSLocale.currentLocale
      end
    end

  end
end
::App = BubbleWrap::App
