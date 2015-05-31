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
    COLLECTION_OPERATIONS = [ NSKeyValueChangeInsertion, NSKeyValueChangeRemoval, NSKeyValueChangeReplacement ]
    DEFAULT_OPTIONS = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld

    def observe(target = self, key_path, &block)
      if not registered?(target, key_path)
        target.addObserver(self, forKeyPath:key_path, options:DEFAULT_OPTIONS, context:nil)
      end

      # Add block even if observer is registed, so multiplie blocks can be invoked.
      add_observer_block(target, key_path, &block)
    end

    def unobserve(target = self, key_path)
      if registered?(target, key_path)
        target.removeObserver(self, forKeyPath:key_path)
        remove_observer_block(target, key_path)
      end
    end

    def unobserve_all
      observer_blocks.each do |target, key_paths|
        key_paths.each_key do |key_path|
          target.removeObserver(self, forKeyPath:key_path)
        end
      end

      remove_all_observer_blocks
    end

    # Observer blocks

    private
    # Returns hash of hashes of arrays.
    # Note the side effect: access to key that is not exist will create
    # that key with default value. But this is should not be a problem
    # as long as you depend on has_key method to check existence.
    def observer_blocks
      @observer_blocks ||= Hash.new do |hash, key|
        hash[key] = Hash.new do |subhash, subkey|
          subhash[subkey] = Array.new
        end
      end
    end

    def registered?(target, key_path)
      observer_blocks[target].has_key? key_path.to_s
    end

    def add_observer_block(target, key_path, &block)
      return if target.nil? || key_path.nil? || block.nil?

      block.weak! if BubbleWrap.use_weak_callbacks?

      observer_blocks[target][key_path.to_s] << block
    end

    def remove_observer_block(target, key_path)
      return if target.nil? || key_path.nil?

      key_path = key_path.to_s

      observer_blocks[target].delete(key_path)

      # If there no key_paths left for target, remove the target key
      if observer_blocks[target].empty?
        observer_blocks.delete(target)
      end
    end

    def remove_all_observer_blocks
      observer_blocks.clear
    end

    # NSKeyValueObserving Protocol

    def observeValueForKeyPath(key_path, ofObject: target, change: change, context: context)
      key_paths = observer_blocks[target] || {}
      blocks = key_paths[key_path] || []

      args = change.values_at(NSKeyValueChangeOldKey, NSKeyValueChangeNewKey)
      args << change[NSKeyValueChangeIndexesKey] if collection?(change)

      blocks.each do |block|
        block.call(*args)
      end
    end

    def collection?(change)
      COLLECTION_OPERATIONS.include?(change[NSKeyValueChangeKindKey])
    end

  end
end
