# Mocking the presentViewController
class MailViewController < UIViewController
  attr_accessor :expectation

  def presentViewController(modal, animated: animated, completion: completion)
    expectation.call modal, animated
  end
end

# Monkey-patching MFMailComposeViewController
# So we can access the values that are set.
# This of course breaks MFMailComposeViewController from actually working,
# but it's testable.
class MFMailComposeViewController
  attr_accessor :toRecipients, :ccRecipients, :bccRecipients, :subject, :message, :html, :attachments

  def setToRecipients(r)
    self.toRecipients = r
  end

  def setCcRecipients(r)
    self.ccRecipients = r
  end

  def setBccRecipients(r)
    self.bccRecipients = r
  end

  def setSubject(r)
    self.subject = r
  end

  def setMessageBody(message, isHTML: html)
    self.message = message
    self.html = html
  end

  def addAttachmentData(d, mimeType: mt, fileName: fn)
    if self.attachments == nil
      self.attachments = []
    end
    self.attachments << {:data => d, :mime_type => mt, :file_name => fn}
  end

end

describe BW::Mail do
  describe ".compose" do
    before do
      @view_controller = MailViewController.new
      @standard_mail_options = {
        delegate: @view_controller,
        to: [ "tom@example.com" ],
        cc: [ "itchy@example.com", "scratchy@example.com" ],
        bcc: [ "jerry@example.com" ],
        html: false,
        subject: "My Subject",
        message: "This is my message. It isn't very long.",
        animated: false,
        attachments: [
          {data: "mock dataset A", mime_type: "mock/typeA", file_name: "mock_name_A"},
          {data: "mock dataset B", mime_type: "mock/typeB", file_name: "mock_name_B"},
          {data: "mock dataset C", mime_type: "mock/typeC", file_name: "mock_name_C"},
        ]
      }
    end

    if BW::Mail.can_send_mail? || Device.ios_version.to_f < 10.0
      it "should determine if the device can send mail or not" do
        [true, false].include?(BW::Mail.can_send_mail?).should == true
      end

      it "should open the mail controller in a modal" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.should.be.kind_of(MFMailComposeViewController)
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end

      it "should create a mail controller with the right to: address set" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.toRecipients.should.be.kind_of(Array)
          mail_controller.toRecipients.should == @standard_mail_options[:to]
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end

      it "should create a mail controller with the right cc: address set" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.ccRecipients.should.be.kind_of(Array)
          mail_controller.ccRecipients.should == @standard_mail_options[:cc]
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end

      it "should create a mail controller with the right bcc: address set" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.bccRecipients.should.be.kind_of(Array)
          mail_controller.bccRecipients.should == @standard_mail_options[:bcc]
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end

      it "should create a mail controller with the right subject: set" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.subject.should.be.kind_of(String)
          mail_controller.subject.should == @standard_mail_options[:subject]
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end

      it "should create a mail controller with the right message: set" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.message.should.be.kind_of(String)
          mail_controller.message.should == @standard_mail_options[:message]
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end

      it "should create a mail controller with the right html: set" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.html.should == @standard_mail_options[:html]
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end


      it "should create a mail controller with the right animation" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          animated.should.be.false
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end

      it "should create a mail controller with an array of attachments" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.attachments.should.be.kind_of(Array)
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end

      it "should create a mail controller with the right number of attachments" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.attachments.size.should == 3
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end

      it "should create a mail controller with several attachments, the first of which is a hash of attachments" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.attachments.first.should.be.kind_of(Hash)
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end

      it "should create a mail controller with several attachments, the last of which has 3 keys" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.attachments.last.keys.size.should == 3
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end

      it "should create a mail controller with several attachments, the last of which has a first key :data" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.attachments.last.keys.first.should == :data
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end

      it "should create a mail controller with several attachments, the second of which has the expected mime-type" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.attachments.first[:mime_type] == "mock/typeA"
        }

        BubbleWrap::Mail.compose @standard_mail_options
      end
    end

  end
end
