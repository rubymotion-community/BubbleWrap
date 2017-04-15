module BubbleWrap
  module UIControlWrapper
    def when(events, options = {}, &block)
      events = BW::Constants.get("UIControlEvent", events)

      @callback ||= {}
      @callback[events] ||= []

      unless options[:append]
        @callback[events] = []
        removeTarget(nil, action: nil, forControlEvents: events)
      end

      @callback[events] << block
      block.weak! if BubbleWrap.use_weak_callbacks?
      addTarget(@callback[events].last, action:'call', forControlEvents: events)
    end

    def off(events)
      removeTarget(nil, action:nil, forControlEvents: events)
      @callback.delete events
    end
  end

  Constants.register(
    UIControlEventTouchDown,
    UIControlEventTouchDownRepeat,
    UIControlEventTouchDragInside,
    UIControlEventTouchDragOutside,
    UIControlEventTouchDragEnter,
    UIControlEventTouchDragExit,
    UIControlEventTouchUpInside,
    UIControlEventTouchUpOutside,
    UIControlEventTouchCancel,

    UIControlEventValueChanged,

    UIControlEventEditingDidBegin,
    UIControlEventEditingChanged,
    UIControlEventEditingDidEnd,
    UIControlEventEditingDidEndOnExit,

    UIControlEventAllTouchEvents,
    UIControlEventAllEditingEvents,
    # UIControlEventApplicationReserved,
    # UIControlEventSystemReserved,
    UIControlEventAllEvents
  )
end
