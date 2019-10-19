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

    def delete(key)
      value = storage.objectForKey storage_key(key)
      storage.removeObjectForKey(storage_key(key))
      storage.synchronize
      value
    end

    def storage
      NSUserDefaults.standardUserDefaults
    end

    def storage_key(key)
      "#{app_key}_#{key}"
    end

    def all
      hash = storage.dictionaryRepresentation.select{|k,v| k.start_with?(app_key) }
      new_hash = {}
      hash.each do |k,v|
        new_hash[k.sub("#{app_key}_", '')] = v
      end
      new_hash
    end

    module Archive
      module_function

      SUPPORTED_CLASSES = [TrueClass, FalseClass, NSData, NSString, NSNumber, NSDate, NSArray, NSDictionary]

      def []=(key, value)
        BubbleWrap::Persistence[key] = pack_archive(value)
      end

      def [](key)
        unpack_archive(BubbleWrap::Persistence[key])
      end

      def pack_archive(object)
        case object
        when Array
          object.map{|item| pack_archive(item)}
        when Hash
          object.inject({}) do |result, (key, value)|
            result[pack_archive(key)] = pack_archive(value)
            result
          end
        when NSData, NSCFData
          raise "Can't store NSData objects in BubbleWrap::Persistence::Archive"
        when *SUPPORTED_CLASSES
          object
        else  
          NSKeyedArchiver.archivedDataWithRootObject(object)
        end
      end

      def unpack_archive(object)
        case object
        when Array
          object.map{|item| unpack_archive(item)}
        when Hash
          object.inject({}) do |result, (key, value)|
            result[unpack_archive(key)] = unpack_archive(value)
            result
          end
        when NSData, NSCFData
          NSKeyedUnarchiver.unarchiveObjectWithData(object)
        else
          # RubyMotion currently has a bug where the strings returned from
          # standardUserDefaults are missing some methods (e.g. to_data).
          # And because the returned object is slightly different than a normal
          # String, we can't just use `value.is_a?(String)`

          if object.class.to_s == 'String'
            object.dup
          else
            object
          end
        end
      end

      def supported_class?(object)
        SUPPORTED_CLASSES.find { |supported_class| object.kind_of?(supported_class) }
      end

    end
  end

end
::Persistence = BubbleWrap::Persistence unless defined?(::Persistence)
