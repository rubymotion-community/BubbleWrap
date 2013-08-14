# Mocking the presentViewController
class MessageViewController < UIViewController
  attr_accessor :expectation
  
  def presentModalViewController(modal, animated: animated)
    expectation.call modal, animated
  end
end

# Monkey-patching MFMessageComposeViewController
# So we can access the values that are set.
# This of course breaks MFMessageComposeViewController from actually working,
# but it's testable.
class MFMessageComposeViewController
  attr_accessor :recipients, :body
end

describe BW::Message do
  describe ".compose" do
    before do
      @view_controller = MessageViewController.new
      @standard_message_options = {
        delegate: @view_controller,
        to: [ "1(234)567-8910" ],
        message: "This is my message. It isn't very long.",
        animated: false
      }
    end
    
    it "should open the message controller in a modal" do
      @view_controller.expectation = lambda { |message_controller, animated|
        message_controller.should.be.kind_of(MFMessageComposeViewController)
      }
      
      BW::Message.compose @standard_message_options
    end
    
    # it "should create a mail controller with the right to: address set" do
    #   @view_controller.expectation = lambda { |mail_controller, animated|
    #     mail_controller.toRecipients.should.be.kind_of(Array)
    #     mail_controller.toRecipients.should == @standard_mail_options[:to]
    #   }
      
    #   BubbleWrap::Mail.compose @standard_mail_options
    # end

    # it "should create a mail controller with the right cc: address set" do
    #   @view_controller.expectation = lambda { |mail_controller, animated|
    #     mail_controller.ccRecipients.should.be.kind_of(Array)
    #     mail_controller.ccRecipients.should == @standard_mail_options[:cc]
    #   }
      
    #   BubbleWrap::Mail.compose @standard_mail_options
    # end

    # it "should create a mail controller with the right bcc: address set" do
    #   @view_controller.expectation = lambda { |mail_controller, animated|
    #     mail_controller.bccRecipients.should.be.kind_of(Array)
    #     mail_controller.bccRecipients.should == @standard_mail_options[:bcc]
    #   }
      
    #   BubbleWrap::Mail.compose @standard_mail_options
    # end

    # it "should create a mail controller with the right subject: set" do
    #   @view_controller.expectation = lambda { |mail_controller, animated|
    #     mail_controller.subject.should.be.kind_of(String)
    #     mail_controller.subject.should == @standard_mail_options[:subject]
    #   }
      
    #   BubbleWrap::Mail.compose @standard_mail_options
    # end

    # it "should create a mail controller with the right message: set" do
    #   @view_controller.expectation = lambda { |mail_controller, animated|
    #     mail_controller.message.should.be.kind_of(String)
    #     mail_controller.message.should == @standard_mail_options[:message]
    #   }
      
    #   BubbleWrap::Mail.compose @standard_mail_options
    # end

    # it "should create a mail controller with the right html: set" do
    #   @view_controller.expectation = lambda { |mail_controller, animated|
    #     mail_controller.html.should == @standard_mail_options[:html]
    #   }
      
    #   BubbleWrap::Mail.compose @standard_mail_options
    # end

    # it "should create a mail controller with the right animation" do
    #   @view_controller.expectation = lambda { |mail_controller, animated|
    #     animated.should.be.false
    #   }
      
    #   BubbleWrap::Mail.compose @standard_mail_options
    # end

  end
end
