module BubbleWrap
  module Message

    module_function

    # Base method to create your in-app mail
    # ---------------------------------------
    # EX
    #   BW::Message.compose {
    #     delegate: self, # optional, will use root view controller by default
    #     to: [ "1(234)567-8910" ],
    #     message: "This is my message. It isn't very long.",
    #     animated: false
    #   } do |result, error|
    #     result.sent?      # => boolean
    #     result.canceled?  # => boolean
    #     result.failed?    # => boolean
    #     error             # => NSError
    #   end
    def compose(options={}, &callback)
      @delegate = options[:delegate] || App.window.rootViewController
      @callback = callback
      @message_controller = create_message_controller(options)
      @message_is_animated = options[:animated] == false ? false : true
      @delegate.presentModalViewController(@message_controller, animated: @mailer_is_animated)
    end
    
    def create_message_controller(options={})
      message_controller = MFMessageComposeViewController.alloc.init
      message_controller.messageComposeDelegate = self
      message_controller.body = options[:message]      
      message_controller
    end

    # Event when the MFMessageComposeViewController is closed
    # -------------------------------------------------------------
    # the callback is fired if it was present in the constructor

    def messageComposeViewController(controller, didFinishWithResult: result)
      @delegate.dismissModalViewControllerAnimated(@message_is_animated)
      @callback.call Result.new(result) if @callback
    end
  end
end
