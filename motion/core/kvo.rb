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

    def observe(*arguments, &block)
      unless [1,2].include?(arguments.length)
        raise ArgumentError, "wrong number of arguments (#{arguments.length} for 1 or 2)"
      end

      key_path = arguments.pop
      target   = arguments.pop || self

      target.addObserver(self, forKeyPath:key_path, options:DEFAULT_OPTIONS, context:nil) unless registered?(target, key_path)
      add_observer_block(target, key_path, &block)
    end

    def unobserve(*arguments)
      unless [1,2].include?(arguments.length)
        raise ArgumentError, "wrong number of arguments (#{arguments.length} for 1 or 2)"
      end

      key_path = arguments.pop
      target   = arguments.pop || self

      return unless registered?(target, key_path)

      target.removeObserver(self, forKeyPath:key_path)
      remove_observer_block(target, key_path)
    end

    def unobserve_all
      return if @targets.nil?

      @targets.each do |target, key_paths|
        key_paths.each_key do |key_path|
          target.removeObserver(self, forKeyPath:key_path)
        end
      end
      remove_all_observer_blocks
    end

    # Observer blocks

    private
    def registered?(target, key_path)
      !@targets.nil? && !@targets[target].nil? && @targets[target].has_key?(key_path.to_s)
    end

    def add_observer_block(target, key_path, &block)
      return if target.nil? || key_path.nil? || block.nil?

      block.weak! if BubbleWrap.use_weak_callbacks?

      @targets ||= {}
      @targets[target] ||= {}
      @targets[target][key_path.to_s] ||= []
      @targets[target][key_path.to_s] << block
    end

    def remove_observer_block(target, key_path)
      return if @targets.nil? || target.nil? || key_path.nil?

      key_paths = @targets[target]
      key_paths.delete(key_path.to_s) if !key_paths.nil?
      if key_paths.nil? || key_paths.length == 0
        @targets.delete(target)
      end
    end

    def remove_all_observer_blocks
      @targets.clear unless @targets.nil?
    end

    # NSKeyValueObserving Protocol

    def observeValueForKeyPath(key_path, ofObject: target, change: change, context: context)
      key_paths = @targets[target] || {}
      blocks = key_paths[key_path] || []
      blocks.each do |block|
        args = [change[NSKeyValueChangeOldKey], change[NSKeyValueChangeNewKey]]
        args << change[NSKeyValueChangeIndexesKey] if collection?(change)
        block.call(*args)
      end
    end

    def collection?(change)
      COLLECTION_OPERATIONS.include?(change[NSKeyValueChangeKindKey])
    end

  end
end
