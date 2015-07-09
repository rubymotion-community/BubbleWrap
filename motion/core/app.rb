# Provides a module to store global states
#
module BubbleWrap
  module App
    include BubbleWrap::Deprecated

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
    deprecated :user_cache, "2.0.0"

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

    @states = {}

    def states
      @states
    end

    def info_plist
      NSBundle.mainBundle.infoDictionary
    end

    def name
      info_plist['CFBundleDisplayName']
    end

    def identifier
      NSBundle.mainBundle.bundleIdentifier
    end

    def version
      info_plist['CFBundleVersion']
    end

    def short_version
      info_plist['CFBundleShortVersionString']
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

    def osx?
      Kernel.const_defined?(:NSApplication)
    end

    def ios?
      Kernel.const_defined?(:UIApplication)
    end
  end

end
::App = BubbleWrap::App unless defined?(::App)
