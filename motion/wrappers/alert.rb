module Wrappers
  class Alert
    extend BW::Wrappers::NativeAttributes

    native_attributes :show, :title, :message, :numberOfButtons, :cancelButtonIndex, :delegate, :visible
    attr_accessor :native
    aliased_native_attributes style: :alertViewStyle

    STYLE_OPTIONS = %w(default secure plain login)
    STYLE_DEFAULT = UIAlertViewStyleDefault
    STYLE_SECURE  = UIAlertViewStyleSecureTextInput
    STYLE_PLAIN   = UIAlertViewStylePlainTextInput
    STYLE_LOGIN   = UIAlertViewStyleLoginAndPasswordInput

    def initialize(title, message, options={})
      delegate              = options[:delegate]
      cancel_button         = options[:cancel_button]||"OK"
      other_buttons         = options[:other_buttons]
      style                 = options[:style] ? BW::Alert.const_get("STYLE_#{options[:style].upcase}") : STYLE_DEFAULT
      @native               = UIAlertView.alloc.initWithTitle(title, message: message,
                                  delegate: delegate, cancelButtonTitle: cancel_button, otherButtonTitles: other_buttons)
      style                 = style
      self
    end

    def style=(style)
      if BW::Alert.const_defined?("STYLE_#{style.upcase}")
        @native.alertViewStyle = BW::Alert.const_get("STYLE_#{style.upcase}")
      else
        raise "UIView Alert Style #{style} does not exist. Valid options are #{STYLE_OPTIONS.join(", ")}"
      end
      @native
    end

  end
  ::Alert = BubbleWrap::Wrappers::Alert unless defined?(::Alert)
end
