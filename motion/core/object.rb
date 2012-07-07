module BubbleWrap
  module Object
    def method_missing(method, *args)
      if method.to_s =~ /^new[A-Z].+/
        return delegate_new_to_alloc_init method, *args
      end

      super
    end

    private

    def delegate_new_to_alloc_init(method, *args)
      methods = [method.to_s.gsub(/^new/, 'init')]

      if args.last.is_a? Hash
        inline_arguments = args.pop

        inline_arguments.each do |key, value|
          methods << key
          args << value
        end
      end

      self.alloc.send methods.join(':'), *args
    end
  end
end

Object.send :extend, BubbleWrap::Object
