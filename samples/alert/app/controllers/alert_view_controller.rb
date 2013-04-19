class AlertViewController < UIViewController
  attr_reader :text_view
  attr_reader :buttons
  attr_reader :alerts

  def init
    super.tap do
      @buttons = []
      @alerts  = []
    end
  end

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.grayColor

    @text_view = build_text_view
    self.view.addSubview(self.text_view)

    self.buttons << build_button("Default")
    self.alerts  << built_alert(:default)

    self.buttons << build_button("Plain Text")
    self.alerts  << built_alert(:plain_text_input)

    self.buttons << build_button("Secure Text")
    self.alerts  << built_alert(:secure_text_input)

    self.buttons << build_button("Login and Password")
    self.alerts  << built_alert(:login_and_password_input)

    self.buttons.each_with_index do |button, index|
      self.view.addSubview(button)

      button.when(UIControlEventTouchUpInside) do
        self.alerts[index].show
      end
    end
  end

  def build_text_view
    text_view = UITextView.alloc.initWithFrame([[20, 10], [280, 184]])
    text_view.editable = false
    text_view.text     = "Waiting..."
    text_view
  end

  def build_button(title)
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle(title, forState:UIControlStateNormal)

    rect = self.buttons.empty? ? CGRectMake(20, 150, 280, 44) : self.buttons.last.frame
    button.frame = [[rect.origin.x, rect.origin.y + rect.size.height + 20], rect.size]

    button
  end

  def built_alert(method)
    alert = BW::UIAlertView.send(method, :title => method) do |index|
      self.text_view.text += "\n#{method} on_click: #{index}"
      self.text_view.selectedRange = NSMakeRange(self.text_view.text.length, 0)
    end

    alert.will_present do
      self.text_view.text += "\n\n#{method} will_present"
      self.text_view.selectedRange = NSMakeRange(self.text_view.text.length, 0)
    end

    alert.did_present do
      self.text_view.text += "\n#{method} did_present"
      self.text_view.selectedRange = NSMakeRange(self.text_view.text.length, 0)
    end

    alert.will_dismiss do |index|
      self.text_view.text += "\n#{method} will_dismiss: #{index}"
      self.text_view.selectedRange = NSMakeRange(self.text_view.text.length, 0)
    end

    alert.did_dismiss do |index|
      self.text_view.text += "\n#{method} did_dismiss: #{index}"
      self.text_view.selectedRange = NSMakeRange(self.text_view.text.length, 0)
    end

    alert
  end
end
