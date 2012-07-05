# Opens UIView to add methods for working with gesture recognizers.

class UIView

  def whenTapped(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UITapGestureRecognizer.alloc.initWithTarget(self, action:'motionHandleGesture:'))
  end

  def whenPinched(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UIPinchGestureRecognizer.alloc.initWithTarget(self, action:'motionHandleGesture:'))
  end

  def whenRotated(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UIRotationGestureRecognizer.alloc.initWithTarget(self, action:'motionHandleGesture:'))
  end

  def whenSwiped(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UISwipeGestureRecognizer.alloc.initWithTarget(self, action:'motionHandleGesture:'))
  end

  def whenPanned(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UIPanGestureRecognizer.alloc.initWithTarget(self, action:'motionHandleGesture:'))
  end

  def whenPressed(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UILongPressGestureRecognizer.alloc.initWithTarget(self, action:'motionHandleGesture:'))
  end

  private

  def motionHandleGesture(recognizer)
    @recognizers[recognizer].call(recognizer)
  end

  # Adds the recognizer and keeps a strong reference to the Proc object.
  def addGestureRecognizerHelper(proc, enableInteraction, recognizer)
    setUserInteractionEnabled true if enableInteraction && !isUserInteractionEnabled
    self.addGestureRecognizer(recognizer)

    @recognizers = {} unless @recognizers
    @recognizers[recognizer] = proc

    recognizer
  end

end