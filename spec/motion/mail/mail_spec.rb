describe BubbleWrap::Mail do
  describe ".compose" do
    before do
      @standard_mail_options = {
        to: [ "tom@example.com" ],
        cc: [ "itchy@example.com", "scratchy@example.com" ]
        bcc: [ "jerry@example.com" ],
        html: false,
        message: "This is my message. It isn't very long.",
        animated: false
      }
    end
    
    it "should open the mail controller in a modal" do
      view_controller = mock()
      view_controller.expects("presentModalViewController:animated:")
      BubbleWrap::Mail.compose view_controller, @standard_mail_options
    end
    
    it "should create a mail controller" do
      view_controller = UIViewController.new
      BubbleWrap::Mail.compose view_controller, @standard_mail_options
      view_controller.modalViewController.should.be.kind_of(MFMailComposeViewController)
    end

  end
end
