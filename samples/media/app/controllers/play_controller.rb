class PlayController < UIViewController
  attr_accessor :buttons

  def init
    super.tap do
      @buttons = []
    end
  end

  def viewDidLoad
    super

    self.view.addSubview(build_button("Modal", "tapped_modal"))
    self.view.addSubview(build_button("Frame", "tapped_frame"))
    self.view.backgroundColor = UIColor.whiteColor
  end

  def build_button(title, callback)
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle(title, forState:UIControlStateNormal)
    button.sizeToFit

    rect = self.buttons.empty? ? CGRectMake(0, 0, 0, 0) : self.buttons.last.frame

    button.frame = [[rect.origin.x, rect.origin.y + rect.size.height + 10], button.frame.size]
    button.addTarget(self, action: callback, forControlEvents:UIControlEventTouchUpInside)

    self.buttons << button
    button
  end

  def local_file
    NSURL.fileURLWithPath(File.join(NSBundle.mainBundle.resourcePath, 'test.mp3'))
  end

  def tapped_modal
    BW::Media.play_modal(local_file)
  end

  def tapped_frame
    BW::Media.play(local_file) do |media_player|
      media_player.view.frame = [[10, 140], [self.view.frame.size.width - 20, 100]]
      self.view.addSubview media_player.view
    end
  end
end
