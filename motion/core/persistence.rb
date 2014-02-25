# Persistence module built on top of NSUserDefaults
module BubbleWrap
  module Persistence
    module_function

    def []=(key, value)
      storage.setObject(value, forKey: key)
      storage.synchronize
    end

    def [](key)
      value = storage.objectForKey(key)

      # RubyMotion currently has a bug where the strings returned from
      # standardUserDefaults are missing some methods (e.g. to_data).
      # And because the returned object is slightly different than a normal
      # String, we can't just use `value.is_a?(String)`
      value.class.to_s == 'String' ? value.dup : value
    end

    def merge(values)
      values.each do |key, value|
        storage.setObject(value, forKey: key)
      end
      storage.synchronize
    end

    def delete(key)
      value = storage.objectForKey(key)
      storage.removeObjectForKey(key)
      storage.synchronize
      value
    end

    def storage
      NSUserDefaults.standardUserDefaults
    end
  end
end
::Persistence = BubbleWrap::Persistence unless defined?(::Persistence)
