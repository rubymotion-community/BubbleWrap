# Provides a module to store global states and a persistence layer.
#
module App
  module_function

  @states = {}

  def states
    @states
  end

  def name
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
      defaults.setObject(value, forKey: storage_key(key))
      defaults.synchronize
    end

    def self.[](key)
      defaults = NSUserDefaults.standardUserDefaults
      defaults.objectForKey storage_key(key)
    end

    private

    def storage_key(key)
      app_key + '_' + key
    end
  end

end
