# Opens UIView to add methods for working with gesture recognizers.

class UIView

  def when_tapped(enableInteraction=true, &proc)
    add_gesture_recognizer_helper(UITapGestureRecognizer.alloc.initWithTarget(self, action:'handle_gesture:'), enableInteraction, proc)
  end

  def when_pinched(enableInteraction=true, &proc)
    add_gesture_recognizer_helper(UIPinchGestureRecognizer.alloc.initWithTarget(self, action:'handle_gesture:'), enableInteraction, proc)
  end

  def when_rotated(enableInteraction=true, &proc)
    add_gesture_recognizer_helper(UIRotationGestureRecognizer.alloc.initWithTarget(self, action:'handle_gesture:'), enableInteraction, proc)
  end

  def when_swiped(enableInteraction=true, &proc)
    add_gesture_recognizer_helper(UISwipeGestureRecognizer.alloc.initWithTarget(self, action:'handle_gesture:'), enableInteraction, proc)
  end

  def when_panned(enableInteraction=true, &proc)
    add_gesture_recognizer_helper(UIPanGestureRecognizer.alloc.initWithTarget(self, action:'handle_gesture:'), enableInteraction, proc)
  end

  def when_pressed(enableInteraction=true, &proc)
    add_gesture_recognizer_helper(UILongPressGestureRecognizer.alloc.initWithTarget(self, action:'handle_gesture:'), enableInteraction, proc)
  end
  
  def self.deprecated_methods
    %w(whenTapped whenPinched whenRotated whenSwiped whenPanned whenPressed)
  end

  deprecated_methods.each do |method|
    define_method(method) do |enableInteraction = true, &proc|
      NSLog "[DEPRECATED - #{method}] please use #{method.underscore} instead."
      send(method.underscore, enableInteraction, &proc)
    end
  end

  private

  def handle_gesture(recognizer)
    @recognizers[recognizer].call(recognizer)
  end

  # Adds the recognizer and keeps a strong reference to the Proc object.
  def add_gesture_recognizer_helper(recognizer, enableInteraction, proc)
    setUserInteractionEnabled true if enableInteraction && !isUserInteractionEnabled
    self.addGestureRecognizer(recognizer)

    @recognizers = {} unless @recognizers
    @recognizers[recognizer] = proc

    recognizer
  end

end