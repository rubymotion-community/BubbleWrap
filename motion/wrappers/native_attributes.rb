module Wrappers
  module NativeAttributes
    def native_attributes(*native_attributes)
      native_attributes.each do |native_attribute|
        native_reader(native_attribute)
        native_writer(native_attribute)
      end
    end

    def native_reader(native_attribute, opts={})
      attribute = opts[:wrapped_method] ? opts[:wrapped_method].to_s.underscore : native_attribute.to_s.underscore
      define_method attribute do
        @native.send native_attribute
      end
    end

    def native_writer(native_attribute, opts={})
      attribute = opts[:wrapped_method] ? opts[:wrapped_method].to_s.underscore : native_attribute.to_s.underscore
      define_method "#{attribute}=" do |value|
        @native.send "#{native_attribute.to_s}=", value
      end
    end

    def aliased_native_attributes(setters={})
      setters.each do |wrapped_method, native_attribute|
        next if self.method_defined?(wrapped_method.to_s)
        native_reader(native_attribute, wrapped_method: wrapped_method)
        native_writer(native_attribute, wrapped_method: wrapped_method)
      end
    end
  end
end
