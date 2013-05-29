# Mocking the presentViewController
class MailViewController < UIViewController
  attr_accessor :expectation
  
  def presentModalViewController(modal, animated: animated)
    expectation.call modal, animated
  end
end

describe BW::Mail do
  describe ".compose" do
    before do
      @view_controller = MailViewController.new
      @standard_mail_options = {
        to: [ "tom@example.com" ],
        cc: [ "itchy@example.com", "scratchy@example.com" ],
        bcc: [ "jerry@example.com" ],
        html: false,
        message: "This is my message. It isn't very long.",
        animated: false
      }
    end
    
    it "should open the mail controller in a modal" do
      @view_controller.expectation = lambda { |mail_controller, animated|
        mail_controller.should.be.kind_of(MFMailComposeViewController)
      }
      
      BubbleWrap::Mail.compose @view_controller, @standard_mail_options
    end
    
    it "should create a mail controller with the right to: address set" do
      @view_controller.expectation = lambda { |mail_controller, animated|
        mail_controller.instance_variable_get("_toRecipients").should.be.kind_of(Array)
      }
      
      BubbleWrap::Mail.compose @view_controller, @standard_mail_options
    end

  end
end
