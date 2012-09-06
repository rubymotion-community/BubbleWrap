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


  def whenTapped(enableInteraction=true, &proc)
    NSLog "[DEPRECATED - whenTapped] please use when_tapped instead."
    when_tapped(enableInteraction, &proc)
  end

  def whenPinched(enableInteraction=true, &proc)
    NSLog "[DEPRECATED - whenPinched] please use when_pinched instead."
    when_pinched(enableInteraction, &proc)
  end

  def whenRotated(enableInteraction=true, &proc)
    NSLog "[DEPRECATED - whenRotated] please use when_rotated instead."
    when_rotated(enableInteraction, &proc)
  end

  def whenSwiped(enableInteraction=true, &proc)
    NSLog "[DEPRECATED - whenSwiped] please use when_swiped instead."
    when_swiped(enableInteraction, &proc)
  end

  def whenPanned(enableInteraction=true, &proc)
    NSLog "[DEPRECATED - whenPanned] please use when_panned instead."
    when_panned(enableInteraction, &proc)
  end

  def whenPressed(enableInteraction=true, &proc)
    NSLog "[DEPRECATED - whenPressed] please use when_pressed instead."
    when_pressed(enableInteraction, &proc)
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