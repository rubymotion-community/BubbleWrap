module BubbleWrap
  module Mail

    module_function

    # Base method to create your in-app mail
    # ---------------------------------------
    # EX
    #   BW::Mail.compose(
    #     delegate: self, # optional, will use root view controller by default
    #     to: [ "tom@example.com" ],
    #     cc: [ "itchy@example.com", "scratchy@example.com" ],
    #     bcc: [ "jerry@example.com" ],
    #     html: false,
    #     subject: "My Subject",
    #     message: "This is my message. It isn't very long.",
    #     animated: false,
    #     attachments: [ { data: nsdata-object1, mime_type: "xxx1/yyy1", file_name: "aaa1.bb1"},
    #                    { data: nsdata-object2, mime_type: "xxx2/yyy2", file_name: "aaa2.bb2"},
    #                    ...
    #                   ]
    #   ) do |result, error|
    #     result.sent?      # => boolean
    #     result.canceled?  # => boolean
    #     result.saved?     # => boolean
    #     result.failed?    # => boolean
    #     error             # => NSError
    #   end
    def compose(options = {}, &callback)
      options = {
        delegate: App.window.rootViewController,
        animated: true,
        html: false,
        to: [],
        cc: [],
        bcc: [],
        subject: 'Contact',
        attachments: []
      }.merge(options)

      @delegate = options[:delegate]
      @mailer_is_animated = options[:animated]
      @callback = callback
      @callback.weak! if @callback && BubbleWrap.use_weak_callbacks?

      @mail_controller = create_mail_controller(options)

      @delegate.presentViewController(@mail_controller, animated: @mailer_is_animated, completion: options[:completion])
    end

    def create_mail_controller(options = {})
      unless can_send_mail?
        controller = UIAlertController.alertControllerWithTitle("Email", message:"Cannot compose an email. Please run on device.", preferredStyle:UIAlertControllerStyleAlert)
        controller.addAction(UIAlertAction.actionWithTitle:"OK",style:UIAlertActionStyleDefault, handler:@callback)
        return controller
      end

      mail_controller = MFMailComposeViewController.alloc.init

      mail_controller.mailComposeDelegate = self
      mail_controller.setToRecipients(Array(options[:to]))
      mail_controller.setCcRecipients(Array(options[:cc]))
      mail_controller.setBccRecipients(Array(options[:bcc]))
      mail_controller.setSubject(options[:subject])
      mail_controller.setMessageBody(options[:message], isHTML: !!options[:html])
      options[:attachments].each do |ad|
        mail_controller.addAttachmentData(ad[:data], mimeType: ad[:mime_type], fileName: ad[:file_name])
      end
      mail_controller
    end

    def can_send_mail?
      !!MFMailComposeViewController.canSendMail
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
