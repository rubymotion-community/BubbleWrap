module BW
  module UIBarButtonItem
    module_function

    def styled(type, *objects, &block)
      action = block ? :call : nil
      object = objects.size == 1 ? objects.first : objects
      style  = Constants.get("UIBarButtonItemStyle", type)

      item = if object.is_a?(String)
        ::UIBarButtonItem.alloc.initWithTitle(object,
          style:style,
          target:block,
          action:action
        )
      elsif object.is_a?(UIImage)
        ::UIBarButtonItem.alloc.initWithImage(object,
          style:style,
          target:block,
          action:action
        )
      elsif object.is_a?(Array) && object.size == 2 && object.all? { |o| o.is_a?(UIImage) }
        ::UIBarButtonItem.alloc.initWithImage(object[0],
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
      action      = block ? :call : nil
      system_item = Constants.get("UIBarButtonSystemItem", type)

      item = ::UIBarButtonItem.alloc.initWithBarButtonSystemItem(system_item,
        target:block,
        action:action
      )
      item.instance_variable_set(:@target, block)
      item
    end

    def custom(view, &block)
      view.when_tapped(true, &block) if block
      ::UIBarButtonItem.alloc.initWithCustomView(view)
    end

    def build(options = {}, &block)
      if options[:styled]
        args = options.values_at(:title, :image, :landscape).compact
        return styled(options[:styled], *args, &block)
      end

      return system(options[:system], &block) if options[:system]

      return custom(options[:custom], &block) if options[:custom]
      return custom(options[:view],   &block) if options[:view]

      raise ArgumentError, "invalid options - #{options.inspect}"
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
