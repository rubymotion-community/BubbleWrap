module BubbleWrap
  module Deprecated

    class DeprecatedError < StandardError; end

    def deprecated(method_sym, version)
      unless method_sym.kind_of?(Symbol)
        raise ArgumentError, "deprecated() requires symbols for its first argument."
      end

      scope = nil
      alias_scope = nil
      if self.methods.include?(method_sym)
        scope = :define_singleton_method
        alias_scope = (class << self; self end)
      elsif self.instance_methods.include?(method_sym)
        scope = :define_method
        alias_scope = self
      else
        raise ArgumentError, "Method not found for deprecated() - #{method_sym}"
      end


      send(scope, "#{method_sym}_with_deprecation", ->(*args, &block) {
        fail = BubbleWrap.version.to_s >= version.to_s
        if fail
          raise DeprecatedError, "#{method_sym} was deprecated and removed in BubbleWrap #{version}"
        else
          NSLog "#{method_sym} is deprecated -- it will be removed in BubbleWrap #{version}"
          send("#{method_sym}_without_deprecation", *args, &block)
        end
      })

      alias_scope.send(:alias_method, "#{method_sym}_without_deprecation", method_sym)
      alias_scope.send(:alias_method, method_sym, "#{method_sym}_with_deprecation")
    end

    def self.included(base)
      base.extend(self)
    end
  end
end
