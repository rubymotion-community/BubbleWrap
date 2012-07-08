# Persistence module built on top of NSUserDefaults
module BubbleWrap
  module Persistence
    module_function

    def app_key
      @app_key ||= BubbleWrap::App.identifier
    end

    def []=(key, value)
      storage.setObject(value, forKey: storage_key(key.to_s))
      storage.synchronize
    end

    def [](key)
      storage.objectForKey storage_key(key.to_s)
    end

    def merge(values)
      values = Hash[values.map{|key, value| [storage_key(key.to_s), value]}]
      storage.registerDefaults values
      storage.synchronize
    end

    def storage
      NSUserDefaults.standardUserDefaults
    end

    def storage_key(key)
      app_key + '_' + key.to_s
    end
  end

end
::Persistence = BubbleWrap::Persistence
