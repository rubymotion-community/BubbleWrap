# Opens UIView to add methods for working with gesture recognizers.

class UIView

  def whenTapped(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UITapGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenPinched(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UIPinchGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenRotated(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UIRotationGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenSwiped(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UISwipeGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenPanned(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UIPanGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenPressed(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UILongPressGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  private

  # Adds the recognizer and keeps a strong reference to the Proc object.
  def addGestureRecognizerHelper(proc, enableInteraction, recognizer)
    setUserInteractionEnabled true if enableInteraction && !isUserInteractionEnabled
    self.addGestureRecognizer(recognizer)
    @recognizers = {} unless @recognizers
    @recognizers["#{proc}"] = proc
  end

end

