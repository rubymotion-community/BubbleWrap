module BubbleWrap
  module Mail

    module_function

    # Base method to create your in-app mail
    # ---------------------------------------
    # EX
    #   BW::Mail.compose self, {
    #     to: [ "tom@example.com" ],
    #     cc: [ "itchy@example.com", "scratchy@example.com" ]
    #     bcc: [ "jerry@example.com" ],
    #   } do |result, error|
    #     result.sent?      # => boolean
    #     result.canceled?  # => boolean
    #     result.saved?     # => boolean
    #     result.failed?    # => boolean
    #     error             # => NSError
    #   end
    def compose(delegate, options={}, &callback)
      @delegate = delegate

      @callback = callback
      
      @mail_controller = create_mail_controller(options)
      
      @mailer_is_animated = options[:animated] == false ? false : true
      @delegate.presentModalViewController(@mail_controller, animated: @mailer_is_animated)
    end
    
    def create_mail_controller(options={})
      mail_controller = MFMailComposeViewController.alloc.init
      
      mail_controller.mailComposeDelegate = self
      mail_controller.setToRecipients(Array(options[:to]))
      mail_controller.setCcRecipients(Array(options[:cc]))
      mail_controller.setBccRecipients(Array(options[:bcc]))
      mail_controller.setSubject(options[:subject] || "Contact")
      is_html = !!options[:html]
      mail_controller.setMessageBody(options[:message], isHTML: is_html)
      
      mail_controller
    end

    # Event when the MFMailComposeViewController is closed
    # -------------------------------------------------------------
    # the callback is fired if it was present in the constructor

    def mailComposeController(controller, didFinishWithResult: result, error: error)
      @delegate.dismissModalViewControllerAnimated(@mailer_is_animated)
      @callback.call Result.new(result, error) if @callback
    end
  end
end
