class GestureView < UIView
  attr_accessor :rotation, :scale, :translation

  def initWithCoder(coder)
    super
    setup
    self
  end

  def initWithFrame(coder)
    super
    setup
    self
  end

  ## UIGestureRecognizerDelegate

  #  Note: this method allow rotate and pinch gesture happen at the same time
  def gestureRecognizer(recognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer:other_recognizer)
    case recognizer
    when @rotated_recognizer
      if other_recognizer == @pinch_recognizer
        return true
      end
    when @pinch_recognizer
      if other_recognizer == @rotated_recognizer
        return true
      end
    end
    return false
  end

  private

  def setup
    self.layer.shouldRasterize = true
    self.rotation = 0
    self.scale = 1
    setup_gesture
  end

  def setup_gesture
    @panned_recognizer = self.whenPanned do |recognizer|
      case(recognizer.state)
      when UIGestureRecognizerStateBegan
        @last_position = self.position
      when UIGestureRecognizerStateChanged
        self.translation = recognizer.translationInView(self.superview)
        self.position = [@last_position.x + self.translation.x, @last_position.y + self.translation.y]
      when UIGestureRecognizerStateEnded
        @last_position = nil
      end
    end
    @panned_recognizer.maximumNumberOfTouches = 1
    @panned_recognizer.minimumNumberOfTouches = 1
    @panned_recognizer.delegate = self

    @rotated_recognizer = self.whenRotated do |recognizer|
      case(recognizer.state)
      when UIGestureRecognizerStateBegan
        @last_rotation = self.rotation
      when UIGestureRecognizerStateChanged
        self.rotation = @last_rotation + recognizer.rotation
        reset_transformation
      when UIGestureRecognizerStateEnded
        @last_rotation = nil
      end
    end
    @rotated_recognizer.delegate = self

    @pinch_recognizer = self.whenPinched do |recognizer|
      case(recognizer.state)
      when UIGestureRecognizerStateBegan
        @last_scale = self.scale
      when UIGestureRecognizerStateChanged
        self.scale = @last_scale * recognizer.scale
        reset_transformation
      when UIGestureRecognizerStateEnded
        @last_scale = nil
      end
    end
    @pinch_recognizer.delegate = self
  end

  def reset_transformation
    transform = CATransform3DIdentity
    transform = CATransform3DRotate(transform, -1 * self.rotation, 0.0, 0.0, -1.0)
    transform = CATransform3DScale(transform, self.scale, self.scale, 1.0)
    self.layer.transform = transform
  end

end