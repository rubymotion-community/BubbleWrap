module BW
  class UIAlertView < ::UIAlertView
    @callbacks = [
      :will_present,
      :did_present,
      :on_system_cancel,
      :on_click,
      :will_dismiss,
      :did_dismiss,
      :enable_first_other_button?
    ]

    class << self
      attr_reader :callbacks

      def new(options = {}, &block)
        view = alloc.initWithTitle(options[:title],
          message: options[:message],
          delegate: nil,
          cancelButtonTitle: nil,
          otherButtonTitles: nil
        )

        Array(options[:buttons]).each { |title| view.addButtonWithTitle(title) }

        view.style               = options[:style]
        view.delegate            = view
        view.cancel_button_index = options[:cancel_button_index]

        view.instance_variable_set(:@handlers, {})
        options[:on_click] ||= block

        callbacks.each do |callback|
          view.send(callback, &options[callback]) if options[callback]
        end

        view
      end

      def default(options = {}, &block)
        options = { buttons: "OK" }.merge!(options)
        new(options.merge!(style: :default), &block)
      end

      def plain_text_input(options = {}, &block)
        options = { buttons: ["Cancel", "OK"], cancel_button_index: 0 }.merge!(options)
        new(options.merge!(style: :plain_text_input), &block)
      end

      def secure_text_input(options = {}, &block)
        options = { buttons: ["Cancel", "OK"], cancel_button_index: 0 }.merge!(options)
        new(options.merge!(style: :secure_text_input), &block)
      end

      def login_and_password_input(options = {}, &block)
        options = { buttons: ["Cancel", "Log in"], cancel_button_index: 0 }.merge!(options)
        new(options.merge!(style: :login_and_password_input), &block)
      end
    end

    def style
      alertViewStyle
    end

    def style=(value)
      self.alertViewStyle = Constants.get("UIAlertViewStyle", value) if value
    end

    def cancel_button_index
      cancelButtonIndex
    end

    def cancel_button_index=(value)
      self.cancelButtonIndex = value if value
    end

    attr_reader :handlers
    protected   :handlers

    callbacks.each do |callback|
      define_method(callback) do |&block|
        self.handlers[callback] ||= block
      end
    end

    # UIAlertViewDelegate protocol ################################################################

    def willPresentAlertView(alert)
      handlers[:will_present].call(alert) if handlers[:will_present]
    end

    def didPresentAlertView(alert)
      handlers[:did_present].call(alert) if handlers[:did_present]
    end

    def alertViewCancel(alert)
      handlers[:on_system_cancel].call(alert) if handlers[:on_system_cancel]
    end

    def alertView(alert, clickedButtonAtIndex:index)
      handlers[:on_click].call(alert, index) if handlers[:on_click]
    end

    def alertView(alert, willDismissWithButtonIndex:index)
      handlers[:will_dismiss].call(alert, index) if handlers[:will_dismiss]
    end

    def alertView(alert, didDismissWithButtonIndex: index)
      handlers[:did_dismiss].call(alert, index) if handlers[:did_dismiss]
    end

    def alertViewShouldEnableFirstOtherButton(alert)
      handlers[:enable_first_other_button?].call(alert) if handlers[:enable_first_other_button?]
    end
  end

  Constants.register(
    UIAlertViewStyleDefault,
    UIAlertViewStylePlainTextInput,
    UIAlertViewStyleSecureTextInput,
    UIAlertViewStyleLoginAndPasswordInput
  )
end
