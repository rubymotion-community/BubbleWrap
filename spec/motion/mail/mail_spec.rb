describe BubbleWrap::Mail do
  describe ".compose" do
    before do
      @view_controller = UIViewController.alloc.initWithNibName(nil, bundle:nil)
      @standard_mail_options = {
        to: [ "tom@example.com" ],
        cc: [ "itchy@example.com", "scratchy@example.com" ],
        bcc: [ "jerry@example.com" ],
        html: false,
        message: "This is my message. It isn't very long.",
        animated: false
      }
    end
    
    def set_up_subject
      BubbleWrap::Mail.compose @view_controller, @standard_mail_options
      @subject = @view_controller.modalViewController
    end
    
    it "should open the mail controller in a modal" do
      view_controller = mock()
      view_controller.expects("presentModalViewController:animated:")
      BubbleWrap::Mail.compose view_controller, @standard_mail_options
    end
    
    it "should create a mail controller and display it as a modal" do
      set_up_subject
      @subject.should.be.kind_of(MFMailComposeViewController)
    end
    
    it "should create a mail controller with the right to: address set" do
      # MFMailComposeViewController doesn't have read accessors, so we have
      # to kind of hack into the object to see if it's working properly.
      set_up_subject
      @subject.instance_variable_get("_toRecipients").should.be.kind_of(Array)
    end

  end
end
