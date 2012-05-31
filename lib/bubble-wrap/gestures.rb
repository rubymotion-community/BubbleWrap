# Opens UIView to add methods for working with gesture recognizers.

class UIView

  def whenTapped(&proc)
    addGestureRecognizerHelper(proc, UITapGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenPinched(&proc)
    addGestureRecognizerHelper(proc, UIPinchGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenRotated(&proc)
    addGestureRecognizerHelper(proc, UIRotationGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenSwiped(&proc)
    addGestureRecognizerHelper(proc, UISwipeGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenPanned(&proc)
    addGestureRecognizerHelper(proc, UIPanGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenPressed(&proc)
    addGestureRecognizerHelper(proc, UILongPressGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  private

  # Adds the recognizer and keeps a strong reference to the Proc object.
  def addGestureRecognizerHelper(proc, recognizer)
    setUserInteractionEnabled true unless isUserInteractionEnabled
    self.addGestureRecognizer(recognizer)
    @recognizers = {} unless @recognizers
    @recognizers["#{proc}"] = proc
  end

end

