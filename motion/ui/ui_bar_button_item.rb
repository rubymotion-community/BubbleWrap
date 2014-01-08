module BW
  class UIBarButtonItem < ::UIBarButtonItem
    class << self
      def styled(type, *objects, &block)
        if block.nil?
          action = nil
        else
          block.weak! if BubbleWrap.use_weak_callbacks?
          action = :call
        end
        object = objects.size == 1 ? objects.first : objects
        style  = Constants.get("UIBarButtonItemStyle", type)

        item = if object.is_a?(String)
          alloc.initWithTitle(object,
            style:style,
            target:block,
            action:action
          )
        elsif object.is_a?(UIImage)
          alloc.initWithImage(object,
            style:style,
            target:block,
            action:action
          )
        elsif object.is_a?(Array) && object.size == 2 && object.all? { |o| o.is_a?(UIImage) }
          alloc.initWithImage(object[0],
            landscapeImagePhone:object[1],
            style:style,
            target:block,
            action:action
          )
        else
          raise ArgumentError, "invalid object - #{object.inspect}"
        end

        item.instance_variable_set(:@target, block)
        item
      end

      def system(type, &block)
        if block.nil?
          action = nil
        else
          block.weak! if BubbleWrap.use_weak_callbacks?
          action = :call
        end
        system_item = Constants.get("UIBarButtonSystemItem", type)

        item = alloc.initWithBarButtonSystemItem(system_item, target:block, action:action)
        item.instance_variable_set(:@target, block)
        item
      end

      def custom(view, &block)
        view.when_tapped(true, &block) if block
        alloc.initWithCustomView(view)
      end

      def new(options = {}, &block)
        if options[:styled]
          args = options.values_at(:title, :image, :landscape).compact
          return styled(options[:styled], *args, &block)
        end

        return system(options[:system], &block) if options[:system]

        return custom(options[:custom], &block) if options[:custom]
        return custom(options[:view],   &block) if options[:view]

        raise ArgumentError, "invalid options - #{options.inspect}"
      end

      def build(options = {}, &block)
        NSLog "[DEPRECATED - BW::UIBarButtonItem.build] please use .new instead."
        new(options, &block)
      end
    end
  end

  Constants.register(
    UIBarButtonItemStylePlain,
    UIBarButtonItemStyleBordered,
    UIBarButtonItemStyleDone,

    UIBarButtonSystemItemDone,
    UIBarButtonSystemItemCancel,
    UIBarButtonSystemItemEdit,
    UIBarButtonSystemItemSave,
    UIBarButtonSystemItemAdd,
    UIBarButtonSystemItemFlexibleSpace,
    UIBarButtonSystemItemFixedSpace,
    UIBarButtonSystemItemCompose,
    UIBarButtonSystemItemReply,
    UIBarButtonSystemItemAction,
    UIBarButtonSystemItemOrganize,
    UIBarButtonSystemItemBookmarks,
    UIBarButtonSystemItemSearch,
    UIBarButtonSystemItemRefresh,
    UIBarButtonSystemItemStop,
    UIBarButtonSystemItemCamera,
    UIBarButtonSystemItemTrash,
    UIBarButtonSystemItemPlay,
    UIBarButtonSystemItemPause,
    UIBarButtonSystemItemRewind,
    UIBarButtonSystemItemFastForward,
    UIBarButtonSystemItemUndo,
    UIBarButtonSystemItemRedo,
    UIBarButtonSystemItemPageCurl,
  )
end
