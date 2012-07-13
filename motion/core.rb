module BubbleWrap
  module_function

  # @return [UIcolor]
  def rgb_color(r,g,b)
    rgba_color(r,g,b,1)
  end

  # @return [UIcolor]
  def rgba_color(r,g,b,a)
    UIColor.colorWithRed((r/255.0), green:(g/255.0), blue:(b/255.0), alpha:a)
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
