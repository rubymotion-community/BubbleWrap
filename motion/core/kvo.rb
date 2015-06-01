# Usage example:
#
# class ExampleViewController < UIViewController
#     include BubbleWrap::KVO
#
#     def viewDidLoad
#         @label = UILabel.alloc.initWithFrame [[20,20],[280,44]]
#         @label.text = ""
#         view.addSubview @label
#
#         observe(@label, :text) do |old_value, new_value|
#             puts "Changed #{old_value} to #{new_value}"
#         end
#     end
#
# end
#
# @see https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html#//apple_ref/doc/uid/10000177i
module BubbleWrap
  module KVO
    class Registry
      COLLECTION_OPERATIONS = [ NSKeyValueChangeInsertion, NSKeyValueChangeRemoval, NSKeyValueChangeReplacement ]
      OPTION_MAP = {
        new: NSKeyValueChangeNewKey,
        old: NSKeyValueChangeOldKey
      }

      attr_reader :callbacks, :keys

      def initialize(value_keys = [:old, :new])
        @keys = value_keys.inject([]) do |acc, key|
          value_change_key = OPTION_MAP[key]

          if value_change_key.nil?
            raise RuntimeError, "Unknown value change key #{key}. Possible keys: #{OPTION_MAP.keys}"
          end

          acc << value_change_key
        end

        @callbacks = Hash.new do |hash, key|
          hash[key] = Hash.new do |subhash, subkey|
            subhash[subkey] = Array.new
          end
        end
      end

      def add(target, key_path, &block)
        return if target.nil? || key_path.nil? || block.nil?

        block.weak! if BubbleWrap.use_weak_callbacks?

        callbacks[target][key_path.to_s] << block
      end

      def remove(target, key_path)
        return if target.nil? || key_path.nil?

        key_path = key_path.to_s

        callbacks[target].delete(key_path)

        # If there no key_paths left for target, remove the target key
        if callbacks[target].empty?
          callbacks.delete(target)
        end
      end

      def registered?(target, key_path)
        callbacks[target].has_key? key_path.to_s
      end

      def remove_all
        callbacks.clear
      end

      def each_key_path
        callbacks.each do |target, key_paths|
          key_paths.each_key do |key_path|
            yield target, key_path
          end
        end
      end

      private

      def observeValueForKeyPath(key_path, ofObject: target, change: change, context: context)
        key_paths = callbacks[target] || {}
        blocks = key_paths[key_path] || []

        args = change.values_at(*keys)
        args << change[NSKeyValueChangeIndexesKey] if collection?(change)

        blocks.each do |block|
          block.call(*args)
        end
      end

      def collection?(change)
        COLLECTION_OPERATIONS.include?(change[NSKeyValueChangeKindKey])
      end
    end

    DEFAULT_OPTIONS = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
    IMMIDEATE_OPTIONS = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial

    def observe(target = self, key_path, &block)
      if not observers_registry.registered?(target, key_path)
        target.addObserver(observers_registry, forKeyPath:key_path, options:DEFAULT_OPTIONS, context:nil)
      end

      # Add block even if observer is registed, so multiplie blocks can be invoked.
      observers_registry.add(target, key_path, &block)
    end

    def observe!(target = self, key_path, &block)
      registered = immediate_observers_registry.registered?(target, key_path)

      immediate_observers_registry.add(target, key_path, &block)

      # We need to first register the block, and then call addObserver, because
      # observeValueForKeyPath will fire immedeately.
      if not registered
        target.addObserver(immediate_observers_registry, forKeyPath:key_path, options: IMMIDEATE_OPTIONS, context:nil)
      end
    end

    def unobserve(target = self, key_path)
      remove_from_registry_if_exists(target, key_path, observers_registry)
    end

    def unobserve!(target = self, key_path)
      remove_from_registry_if_exists(target, key_path, immediate_observers_registry)
    end

    def unobserve_all
      observers_registry.each_key_path do |target, key_path|
        target.removeObserver(observers_registry, forKeyPath:key_path)
      end

      immediate_observers_registry.each_key_path do |target, key_path|
        target.removeObserver(immediate_observers_registry, forKeyPath:key_path)
      end

      observers_registry.remove_all
      immediate_observers_registry.remove_all
    end

    private
    def observers_registry
      @observers_registry ||= Registry.new
    end

    def immediate_observers_registry
      @immediate_observers_registry ||= Registry.new([:new])
    end

    def remove_from_registry_if_exists(target, key_path, registry)
      if registry.registered?(target, key_path)
        target.removeObserver(registry, forKeyPath:key_path)
        registry.remove(target, key_path)
      end
    end
  end
end
