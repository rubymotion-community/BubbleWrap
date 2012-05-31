# Persistence module built on top of NSUserDefaults
module BubbleWrap
  module Persistence
    module_function

    def app_key
      @app_key ||= BubbleWrap::App.identifier
    end

    def []=(key, value)
      defaults = NSUserDefaults.standardUserDefaults
      defaults.setObject(value, forKey: storage_key(key.to_s))
      defaults.synchronize
    end

    def [](key)
      defaults = NSUserDefaults.standardUserDefaults
      defaults.objectForKey storage_key(key.to_s)
    end

    def storage_key(key)
      app_key + '_' + key.to_s
    end
  end

end
::Persistence = BubbleWrap::Persistence
