class CameraController < UIViewController
  attr_accessor :buttons

  def init
    super.tap do
      @buttons = []
    end
  end

  def viewDidLoad
    super

    self.view.addSubview(build_button("Library", :any))
    self.view.addSubview(build_button("Front", :front)) if BW::Device.camera.front?
    self.view.addSubview(build_button("Rear", :rear))   if BW::Device.camera.rear?
  end

  def build_button(title, camera_method)
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle(title, forState:UIControlStateNormal)
    button.sizeToFit

    rect = self.buttons.empty? ? CGRectMake(0, 0, 0, 0) : self.buttons.last.frame

    button.frame = [[rect.origin.x, rect.origin.y + rect.size.height + 10], button.frame.size]

    button.when UIControlEventTouchUpInside do
      BW::Device.camera.send(camera_method).picture(media_types: [:image]) do |result|
        image_view = build_image_view(result[:original_image])
        self.view.addSubview(image_view)

        self.buttons.each { |button| self.view.bringSubviewToFront(button) }
      end
    end

    self.buttons << button
    button
  end

  def build_image_view(image)
    image_view = UIImageView.alloc.initWithImage(image)
    image_view.frame  = [CGPointZero, self.view.frame.size]
    image_view.center = [self.view.frame.size.width / 2, self.view.frame.size.height / 2]
    image_view
  end
end
