shared "an instance with no options" do
  it "has the correct class" do
    @subject.class.should.equal(BW::UIAlertView)
  end

  it "has the correct superclass" do
    @subject.superclass.should.equal(::UIAlertView)
  end

  it "has no title" do
    @subject.title.should.be.nil
  end

  it "has no message" do
    @subject.message.should.be.nil
  end

  it "has the correct delegate" do
    @subject.delegate.should.equal(@subject)
  end

  it "has no will_present handler" do
    @subject.will_present.should.be.nil
  end

  it "has no did_present handler" do
    @subject.did_present.should.be.nil
  end

  it "has no on_system_cancel handler" do
    @subject.on_system_cancel.should.be.nil
  end

  it "has no will_dismiss handler" do
    @subject.will_dismiss.should.be.nil
  end

  it "has no did_dismiss handler" do
    @subject.did_dismiss.should.be.nil
  end

  it "has no enable_first_other_button? handler" do
    @subject.enable_first_other_button?.should.be.nil
  end
end

###################################################################################################

shared "an instance with a full set of options" do
  it "has the correct title" do
    @subject.title.should.equal(@options[:title])
  end

  it "has the correct message" do
    @subject.message.should.equal(@options[:message])
  end

  it "has the correct delegate" do
    @subject.delegate.should.equal(@subject)
  end

  it "has the correct cancel button index" do
    @subject.cancel_button_index.should.equal(@options[:cancel_button_index])
  end

  it "has the correct buttons" do
    @subject.numberOfButtons.should.equal(1)
    @subject.buttonTitleAtIndex(0).should.equal(@options[:buttons])
  end

  it "has no will_present handler" do
    @subject.will_present.should.equal(@options[:will_present])
  end

  it "has no did_present handler" do
    @subject.did_present.should.equal(@options[:did_present])
  end

  it "has no on_system_cancel handler" do
    @subject.on_system_cancel.should.equal(@options[:on_system_cancel])
  end

  it "has the correct on_click handler" do
    @subject.on_click.should.equal(@options[:on_click])
  end

  it "has no will_dismiss handler" do
    @subject.will_dismiss.should.equal(@options[:will_dismiss])
  end

  it "has no did_dismiss handler" do
    @subject.did_dismiss.should.equal(@options[:did_dismiss])
  end

  it "has no enable_first_other_button? handler" do
    @subject.enable_first_other_button?.should.equal(@options[:enable_first_other_button?])
  end
end

###################################################################################################

describe BW::UIAlertView do
  describe ".new" do
    describe "given no options" do
      before do
        @subject = BW::UIAlertView.new
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIAlertViewStyleDefault)
      end

      it "has no buttons" do
        @subject.numberOfButtons.should.equal(0)
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end

      it "has no on_click handler" do
        @subject.on_click.should.be.nil
      end
    end

    ###############################################################################################

    describe "given no options with a block" do
      before do
        @options = {}
        @block   = -> { true }
        @subject = BW::UIAlertView.new(@options, &@block)
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIAlertViewStyleDefault)
      end

      it "has no buttons" do
        @subject.numberOfButtons.should.equal(0)
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@block)
      end
    end

    ###############################################################################################

    describe "given a complete set of options" do
      before do
        @options = {
          :title                      => "title",
          :message                    => "message",
          :style                      => :plain_text_input,
          :buttons                    => "button title",
          :cancel_button_index        => 0,
          :will_present               => -> { true },
          :did_present                => -> { true },
          :on_system_cancel           => -> { true },
          :on_click                   => -> { true },
          :will_dismiss               => -> { true },
          :did_dismiss                => -> { true },
          :enable_first_other_button? => -> { true }
        }
        @subject = BW::UIAlertView.new(@options)
      end

      behaves_like "an instance with a full set of options"
    end

    ###############################################################################################

    describe "given options with multiple button titles" do
      before do
        @options = { buttons: ["first button", "second button"] }
        @subject = BW::UIAlertView.new(@options)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal(@options[:buttons][0])
        @subject.buttonTitleAtIndex(1).should.equal(@options[:buttons][1])
      end
    end

    ###############################################################################################

    describe "given options with both an on_click handler and a block" do
      before do
        @options = { on_click: -> { true }}
        @block   = -> { true }
        @subject = BW::UIAlertView.new(@options, &@block)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@options[:on_click])
      end
    end
  end

  #################################################################################################

  describe ".default" do
    describe "given no options" do
      before do
        @subject = BW::UIAlertView.default
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIAlertViewStyleDefault)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(1)
        @subject.buttonTitleAtIndex(0).should.equal("OK")
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end

      it "has no on_click handler" do
        @subject.on_click.should.be.nil
      end
    end

    ###############################################################################################

    describe "given no options with a block" do
      before do
        @options = {}
        @block   = -> { true }
        @subject = BW::UIAlertView.default(@options, &@block)
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIAlertViewStyleDefault)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(1)
        @subject.buttonTitleAtIndex(0).should.equal("OK")
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@block)
      end
    end

    ###############################################################################################

    describe "given a complete set of options" do
      before do
        @options = {
          :title                      => "title",
          :message                    => "message",
          :style                      => :plain_text_input,
          :buttons                    => "button title",
          :cancel_button_index        => 0,
          :will_present               => -> { true },
          :did_present                => -> { true },
          :on_system_cancel           => -> { true },
          :on_click                   => -> { true },
          :will_dismiss               => -> { true },
          :did_dismiss                => -> { true },
          :enable_first_other_button? => -> { true }
        }
        @subject = BW::UIAlertView.default(@options)
      end

      behaves_like "an instance with a full set of options"
    end

    ###############################################################################################

    describe "given options with multiple button titles" do
      before do
        @options = { buttons: ["first button", "second button"] }
        @subject = BW::UIAlertView.new(@options)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal(@options[:buttons][0])
        @subject.buttonTitleAtIndex(1).should.equal(@options[:buttons][1])
      end
    end

    ###############################################################################################

    describe "given options with a cancel button index" do
      before do
        @options = { cancel_button_index: 0 }
        @subject = BW::UIAlertView.new(@options)
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(0)
      end
    end

    ###############################################################################################

    describe "given options with both an on_click handler and a block" do
      before do
        @options = { on_click: -> { true }}
        @block   = -> { true }
        @subject = BW::UIAlertView.default(@options, &@block)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@options[:on_click])
      end
    end
  end

  #################################################################################################

  describe ".plain_text_input" do
    describe "given no options" do
      before do
        @subject = BW::UIAlertView.plain_text_input
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIAlertViewStylePlainTextInput)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal("Cancel")
        @subject.buttonTitleAtIndex(1).should.equal("OK")
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(0)
      end

      it "has no on_click handler" do
        @subject.on_click.should.be.nil
      end
    end

    ###############################################################################################

    describe "given no options with a block" do
      before do
        @options = {}
        @block   = -> { true }
        @subject = BW::UIAlertView.plain_text_input(@options, &@block)
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIAlertViewStylePlainTextInput)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal("Cancel")
        @subject.buttonTitleAtIndex(1).should.equal("OK")
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(0)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@block)
      end
    end

    ###############################################################################################

    describe "given a complete set of options" do
      before do
        @options = {
          :title                      => "title",
          :message                    => "message",
          :style                      => :default,
          :buttons                    => "button title",
          :cancel_button_index        => 0,
          :will_present               => -> { true },
          :did_present                => -> { true },
          :on_system_cancel           => -> { true },
          :on_click                   => -> { true },
          :will_dismiss               => -> { true },
          :did_dismiss                => -> { true },
          :enable_first_other_button? => -> { true }
        }
        @subject = BW::UIAlertView.plain_text_input(@options)
      end

      behaves_like "an instance with a full set of options"
    end

    ###############################################################################################

    describe "given options with multiple button titles" do
      before do
        @options = { buttons: ["first button", "second button"] }
        @subject = BW::UIAlertView.new(@options)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal(@options[:buttons][0])
        @subject.buttonTitleAtIndex(1).should.equal(@options[:buttons][1])
      end
    end

    ###############################################################################################

    describe "given options with a cancel button index" do
      before do
        @options = { cancel_button_index: -1 }
        @subject = BW::UIAlertView.plain_text_input(@options)
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end
    end

    ###############################################################################################

    describe "given options with both an on_click handler and a block" do
      before do
        @options = { on_click: -> { true }}
        @block   = -> { true }
        @subject = BW::UIAlertView.plain_text_input(@options, &@block)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@options[:on_click])
      end
    end
  end

  #################################################################################################

  describe ".secure_text_input" do
    describe "given no options" do
      before do
        @subject = BW::UIAlertView.secure_text_input
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIAlertViewStyleSecureTextInput)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal("Cancel")
        @subject.buttonTitleAtIndex(1).should.equal("OK")
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(0)
      end

      it "has no on_click handler" do
        @subject.on_click.should.be.nil
      end
    end

    ###############################################################################################

    describe "given no options with a block" do
      before do
        @options = {}
        @block   = -> { true }
        @subject = BW::UIAlertView.secure_text_input(@options, &@block)
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIAlertViewStyleSecureTextInput)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal("Cancel")
        @subject.buttonTitleAtIndex(1).should.equal("OK")
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(0)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@block)
      end
    end

    ###############################################################################################

    describe "given a complete set of options" do
      before do
        @options = {
          :title                      => "title",
          :message                    => "message",
          :style                      => :default,
          :buttons                    => "button title",
          :cancel_button_index        => 0,
          :will_present               => -> { true },
          :did_present                => -> { true },
          :on_system_cancel           => -> { true },
          :on_click                   => -> { true },
          :will_dismiss               => -> { true },
          :did_dismiss                => -> { true },
          :enable_first_other_button? => -> { true }
        }
        @subject = BW::UIAlertView.secure_text_input(@options)
      end

      behaves_like "an instance with a full set of options"
    end

    ###############################################################################################

    describe "given options with multiple button titles" do
      before do
        @options = { buttons: ["first button", "second button"] }
        @subject = BW::UIAlertView.new(@options)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal(@options[:buttons][0])
        @subject.buttonTitleAtIndex(1).should.equal(@options[:buttons][1])
      end
    end

    ###############################################################################################

    describe "given options with a cancel button index" do
      before do
        @options = { cancel_button_index: -1 }
        @subject = BW::UIAlertView.secure_text_input(@options)
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end
    end

    ###############################################################################################

    describe "given options with both an on_click handler and a block" do
      before do
        @options = { on_click: -> { true }}
        @block   = -> { true }
        @subject = BW::UIAlertView.secure_text_input(@options, &@block)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@options[:on_click])
      end
    end
  end

  #################################################################################################

  describe ".login_and_password_input" do
    describe "given no options" do
      before do
        @subject = BW::UIAlertView.login_and_password_input
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIAlertViewStyleLoginAndPasswordInput)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal("Cancel")
        @subject.buttonTitleAtIndex(1).should.equal("Log in")
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(0)
      end

      it "has no on_click handler" do
        @subject.on_click.should.be.nil
      end
    end

    ###############################################################################################

    describe "given no options with a block" do
      before do
        @options = {}
        @block   = -> { true }
        @subject = BW::UIAlertView.login_and_password_input(@options, &@block)
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIAlertViewStyleLoginAndPasswordInput)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal("Cancel")
        @subject.buttonTitleAtIndex(1).should.equal("Log in")
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(0)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@block)
      end
    end

    ###############################################################################################

    describe "given a complete set of options" do
      before do
        @options = {
          :title                      => "title",
          :message                    => "message",
          :style                      => :default,
          :buttons                    => "button title",
          :cancel_button_index        => 0,
          :will_present               => -> { true },
          :did_present                => -> { true },
          :on_system_cancel           => -> { true },
          :on_click                   => -> { true },
          :will_dismiss               => -> { true },
          :did_dismiss                => -> { true },
          :enable_first_other_button? => -> { true }
        }
        @subject = BW::UIAlertView.login_and_password_input(@options)
      end

      behaves_like "an instance with a full set of options"
    end

    ###############################################################################################

    describe "given options with multiple button titles" do
      before do
        @options = { buttons: ["first button", "second button"] }
        @subject = BW::UIAlertView.new(@options)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal(@options[:buttons][0])
        @subject.buttonTitleAtIndex(1).should.equal(@options[:buttons][1])
      end
    end

    ###############################################################################################

    describe "given options with a cancel button index" do
      before do
        @options = { cancel_button_index: -1 }
        @subject = BW::UIAlertView.login_and_password_input(@options)
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end
    end

    ###############################################################################################

    describe "given options with both an on_click handler and a block" do
      before do
        @options = { on_click: -> { true }}
        @block   = -> { true }
        @subject = BW::UIAlertView.login_and_password_input(@options, &@block)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@options[:on_click])
      end
    end
  end

  #################################################################################################

  BW::UIAlertView.callbacks.each do |callback|
    describe ".#{callback}" do
      before do
        @subject = BW::UIAlertView.new
      end

      describe "given no block" do
        before do
          @return = @subject.send(callback)
        end

        it "returns no handler" do
          @return.should.be.nil
        end

        it "has no handler" do
          @subject.send(callback).should.be.nil
        end
      end

      ###############################################################################################

      describe "given a block" do
        before do
          @block  = -> { true }
          @return = @subject.send(callback, &@block)
        end

        it "returns the correct handler" do
          @return.should.equal(@block)
        end

        it "has the correct handler" do
          @subject.send(callback).should.equal(@block)
        end
      end
    end
  end

  #################################################################################################

  describe "#style=" do
    before do
      @subject = BW::UIAlertView.new
    end

    describe "given no style" do
      before do
        @subject.style = nil
      end

      it "has the correct style" do
        @subject.style.should.equal(UIAlertViewStyleDefault)
      end
    end

    ###############################################################################################

    describe "given a style" do
      before do
        @subject.style = :plain_text_input
      end

      it "has the correct style" do
        @subject.style.should.equal(UIAlertViewStylePlainTextInput)
      end
    end
  end

  #################################################################################################

  describe "#cancel_button_index=" do
    before do
      @subject = BW::UIAlertView.new
    end

    describe "given no cancel button index" do
      before do
        @subject.cancel_button_index = nil
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end
    end

    ###############################################################################################

    describe "given a cancel button index" do
      before do
        @subject.cancel_button_index = 0
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(0)
      end
    end
  end

  #################################################################################################

  describe "-willPresentAlertView:" do
    before do
      @subject = BW::UIAlertView.new
    end

    describe "given no will_present handler" do
      it "returns noting" do
        @subject.willPresentAlertView(@subject).should.be.nil
      end
    end

    ###############################################################################################

    describe "given a will_present handler" do
      before do
        @subject.will_present do |alert|
          alert.should.equal(@subject)
          :will_present
        end
      end

      it "returns correctly" do
        @subject.willPresentAlertView(@subject).should.equal(:will_present)
      end
    end
  end

  #################################################################################################

  describe "-didPresentAlertView:" do
    before do
      @subject = BW::UIAlertView.new
    end

    describe "given no did_present handler" do
      it "returns noting" do
        @subject.didPresentAlertView(@subject).should.be.nil
      end
    end

    ###############################################################################################

    describe "given a did_present handler" do
      before do
        @subject.did_present do |alert|
          alert.should.equal(@subject)
          :did_present
        end
      end

      it "returns correctly" do
        @subject.didPresentAlertView(@subject).should.equal(:did_present)
      end
    end
  end

  #################################################################################################

  describe "-alertViewCancel:" do
    before do
      @subject = BW::UIAlertView.new
    end

    describe "given no on_system_cancel handler" do
      it "returns noting" do
        @subject.alertViewCancel(@subject).should.be.nil
      end
    end

    ###############################################################################################

    describe "given an on_system_cancel handler" do
      before do
        @subject.on_system_cancel do |alert|
          alert.should.equal(@subject)
          :on_system_cancel
        end
      end

      it "returns correctly" do
        @subject.alertViewCancel(@subject).should.equal(:on_system_cancel)
      end
    end
  end

  #################################################################################################

  describe "-alertView:clickedButtonAtIndex:" do
    before do
      @subject = BW::UIAlertView.new
    end

    describe "given no on_click handler" do
      it "returns noting" do
        @subject.alertView(@subject, clickedButtonAtIndex:0).should.be.nil
      end
    end

    ###############################################################################################

    describe "given an on_click handler" do
      before do
        @subject.on_click do |alert, index|
          alert.should.equal(@subject)
          index.should.equal(0)
          :on_click
        end
      end

      it "returns correctly" do
        @subject.alertView(@subject, clickedButtonAtIndex:0).should.equal(:on_click)
      end
    end
  end

  #################################################################################################

  describe "-alertView:willDismissWithButtonIndex:" do
    before do
      @subject = BW::UIAlertView.new
    end

    describe "given no will_dismiss handler" do
      it "returns noting" do
        @subject.alertView(@subject, willDismissWithButtonIndex:0).should.be.nil
      end
    end

    ###############################################################################################

    describe "given a will_dismiss handler" do
      before do
        @subject.will_dismiss do |alert, index|
          alert.should.equal(@subject)
          index.should.equal(0)
          :will_dismiss
        end
      end

      it "returns correctly" do
        @subject.alertView(@subject, willDismissWithButtonIndex:0).should.equal(:will_dismiss)
      end
    end
  end

  #################################################################################################

  describe "-alertView:didDismissWithButtonIndex:" do
    before do
      @subject = BW::UIAlertView.new
    end

    describe "given no did_dismiss handler" do
      it "returns noting" do
        @subject.alertView(@subject, didDismissWithButtonIndex:0).should.be.nil
      end
    end

    ###############################################################################################

    describe "given a did_dismiss handler" do
      before do
        @subject.did_dismiss do |alert, index|
          alert.should.equal(@subject)
          index.should.equal(0)
          :did_dismiss
        end
      end

      it "returns correctly" do
        @subject.alertView(@subject, didDismissWithButtonIndex:0).should.equal(:did_dismiss)
      end
    end
  end

  #################################################################################################

  describe "-alertViewShouldEnableFirstOtherButton:" do
    before do
      @subject = BW::UIAlertView.new
    end

    describe "given no enable_first_other_button? handler" do
      it "returns noting" do
        @subject.alertViewShouldEnableFirstOtherButton(@subject).should.be.nil
      end
    end

    ###############################################################################################

    describe "given an enable_first_other_button? handler" do
      before do
        @subject.enable_first_other_button? do |alert|
          alert.should.equal(@subject)
          true
        end
      end

      it "returns correctly" do
        @subject.alertViewShouldEnableFirstOtherButton(@subject).should.equal(true)
      end
    end
  end
end
