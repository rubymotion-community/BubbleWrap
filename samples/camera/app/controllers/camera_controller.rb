class CameraController < UIViewController

  def viewDidLoad
    super

    @buttons = []

    @library = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @library.setTitle("Library", forState:UIControlStateNormal)
    @library.sizeToFit
    @library.when UIControlEventTouchUpInside do
      BW::Device.camera.any.picture(media_types: [:image]) do |result|
        image_view = UIImageView.alloc.initWithImage(result[:original_image])
        add_image_view(image_view)
      end
    end
    self.view.addSubview(@library)
    @buttons << @library

    if BW::Device.camera.front?
      @front = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      @front.setTitle("Front", forState:UIControlStateNormal)
      @front.sizeToFit
      last_button = @buttons.last
      @front.frame = [[last_button.frame.origin.x, last_button.frame.origin.y + last_button.frame.size.height + 10], @front.frame.size]
      @front.when UIControlEventTouchUpInside do
        BW::Device.camera.front.picture(media_types: [:image]) do |result|
          image_view = UIImageView.alloc.initWithImage(result[:original_image])
          add_image_view(image_view)
        end
      end
      self.view.addSubview(@front)
      @buttons << @front
    end

    if BW::Device.camera.rear?
      @rear = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      @rear.setTitle("Read", forState:UIControlStateNormal)
      @rear.sizeToFit
      last_button = @buttons.last
      @rear.frame = [[last_button.frame.origin.x, last_button.frame.origin.y + last_button.frame.size.height + 10], @rear.frame.size]
      @rear.when UIControlEventTouchUpInside do
        BW::Device.camera.rear.picture(media_types: [:image]) do |result|
          image_view = UIImageView.alloc.initWithImage(result[:original_image])
          add_image_view(image_view)
        end
      end
      self.view.addSubview(@rear)
      @buttons << @rear
    end
  end

  def add_image_view(image_view)
    image_view.frame = [CGPointZero, self.view.frame.size]
    image_view.center = [self.view.frame.size.width / 2, self.view.frame.size.height / 2]
    self.view.addSubview(image_view)
    @buttons.each do |button|
      self.view.bringSubviewToFront(button)
    end
  end
end
