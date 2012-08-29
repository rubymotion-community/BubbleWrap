# Persistence module built on top of NSUserDefaults
module BubbleWrap
  module Persistence
    module_function

    def app_key
      @app_key ||= BubbleWrap::App.identifier
    end

    def []=(key, value)
      storage.setObject(value, forKey: storage_key(key))
      storage.synchronize
    end

    def [](key)
      value = storage.objectForKey storage_key(key)

      # RubyMotion currently has a bug where the strings returned from
      # standardUserDefaults are missing some methods (e.g. to_data).
      # And because the returned object is slightly different than a normal
      # String, we can't just use `value.is_a?(String)`
      value.class.to_s == 'String' ? value.dup : value
    end

    def merge(values)
      values.each do |key, value|
        storage.setObject(value, forKey: storage_key(key))
      end
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
::Persistence = BubbleWrap::Persistence unless defined?(::Persistence)
