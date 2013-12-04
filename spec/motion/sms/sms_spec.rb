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

  # for iOS7 compatibility
  # on similators, MFMessageComposeViewController.alloc.init returns nil
  def init
    self
  end
end

describe BW::SMS do
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
      
      BW::SMS.compose @standard_message_options
    end
    
    it "should create a message controller with the right recipient address set" do
      @view_controller.expectation = lambda { |message_controller, animated|
        message_controller.recipients.should.be.kind_of(Array)
        message_controller.recipients.should == @standard_message_options[:to]
      }
      
      BubbleWrap::SMS.compose @standard_message_options
    end


    it "should create a message controller with the right message: set" do
      @view_controller.expectation = lambda { |message_controller, animated|
        message_controller.body.should.be.kind_of(String)
        message_controller.body.should == @standard_message_options[:message]
      }
      
      BubbleWrap::SMS.compose @standard_message_options
    end

    it "should create a mail controller with the right animation" do
      @view_controller.expectation = lambda { |message_controller, animated|
        animated.should.be.false
      }
      BubbleWrap::SMS.compose @standard_message_options
    end

  end
end
