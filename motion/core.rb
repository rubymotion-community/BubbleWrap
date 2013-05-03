module BubbleWrap
  module_function

  # @return [UIcolor]
  def rgb_color(r,g,b)
    rgba_color(r,g,b,1)
  end

  # @return [UIcolor]
  def rgba_color(r,g,b,a)
    r,g,b = [r,g,b].map { |i| i / 255.0}
    if App.osx?
      NSColor.colorWithDeviceRed(r, green: g, blue: b, alpha: a)
    else
      UIColor.colorWithRed(r, green: g, blue:b, alpha:a)
    end
  end

  def localized_string(key, value)
    NSBundle.mainBundle.localizedStringForKey(key, value:value, table:nil)
  end

  # I had issues with #p on the device, this is a temporary workaround
  def p(arg)
    NSLog arg.inspect
  end

  def create_uuid
    uuid = CFUUIDCreate(nil)
    CFUUIDCreateString(nil, uuid)
  end

end
