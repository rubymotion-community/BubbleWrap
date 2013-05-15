class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = "What Is My IP?"
    @mainWindow.orderFrontRegardless

    @button = make_button("Find IP")
    @button.target = self
    @button.action = "fetch_ip"

    @label = make_label("_._._._")

    view = @mainWindow.contentView
    view.addSubview(@button)
    view.addSubview(@label)

    views_hash = {"button" => @button, "label" => @label}

    add_constraint "|-[button(<=200)]-|", to: view, views: views_hash

    add_constraint "|-[label]-|", to: view, views: views_hash

    add_constraint "V:|-[button]-10-[label]-(>=20,<=60)-|", to: view, views: views_hash
  end

  def fetch_ip
    @button.title = "Loading"
    BW::HTTP.get("http://jsonip.com") do |response|
      ip = BW::JSON.parse(response.body.to_str)["ip"]
      @label.stringValue = ip
      @button.title = "Find IP"
    end
  end

  def make_button(title)
    button = NSButton.alloc.initWithFrame(CGRectZero)
    button.title = title
    button.buttonType = NSMomentaryLightButton
    button.bezelStyle = NSRoundedBezelStyle
    button.setTranslatesAutoresizingMaskIntoConstraints(false)
    button
  end

  def make_label(text)
    textField = NSTextField.alloc.initWithFrame(CGRectZero)
    textField.stringValue = text
    textField.alignment = NSCenterTextAlignment
    textField.bezeled = false
    textField.drawsBackground = false
    textField.editable = false
    textField.selectable = false
    textField.setTranslatesAutoresizingMaskIntoConstraints(false)
    textField
  end

  def add_constraint(ascii, params = {})
    view = params[:to]
    views_hash = params[:views]
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(ascii, options: 0, metrics: nil, views: views_hash))
  end
end
