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
  attr_accessor :toRecipients, :ccRecipients, :bccRecipients, :subject, :message, :html, :spec_attachments

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

  def addAttachmentData(attachment)
    self.spec_attachments << attachment
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
        animated: false
      }
      @mail_options_with_attachments = {
        delegate: @view_controller,
        to: [ "tom@example.com" ],
        cc: [ "itchy@example.com", "scratchy@example.com" ],
        bcc: [ "jerry@example.com" ],
        html: false,
        subject: "My Subject",
        message: "This is my message. It isn't very long.",
        animated: false,
        attachments: [
          {data: "mock data", mime_type: "mocktype", file_name: "mock name"},
          {data: "mock data", mime_type: "mocktype", file_name: "mock name"},
          {data: "mock data", mime_type: "mocktype", file_name: "mock name"},
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

      it "should create a mail controller with several attachments" do
        @view_controller.expectation = lambda { |mail_controller, animated|
          mail_controller.spec_attachments.should.be.kind_of(Array)
          mail_controller.spec_attachments.size.should == 3
          mail_controller.spec_attachments.each do |sa|
            sa.should.be.kind_of(Hash)
            sa.keys[0].should == "data"
            sa.keys[1].should == "mime_type"
            sa.keys[2].should == "file_name"
          end
        }

        BubbleWrap::Mail.compose @mail_options_with_attachments
      end

    end

  end
end
