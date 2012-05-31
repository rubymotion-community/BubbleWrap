# Provides a module to store global states and a persistence layer.
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

    # Application Delegate
    def delegate
      UIApplication.sharedApplication.delegate
    end

    # Persistence module built on top of NSUserDefaults
    module Persistence
      def self.app_key
        @app_key ||= App.name
      end

      def self.[]=(key, value)
        defaults = NSUserDefaults.standardUserDefaults
        defaults.setObject(value, forKey: storage_key(key.to_s))
        defaults.synchronize
      end

      def self.[](key)
        defaults = NSUserDefaults.standardUserDefaults
        defaults.objectForKey storage_key(key.to_s)
      end

      private

      def self.storage_key(key)
        app_key + '_' + key.to_s
      end
    end

  end
end
::App = BubbleWrap::App
