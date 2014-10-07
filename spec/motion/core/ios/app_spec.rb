describe BubbleWrap::App do
  describe "iOS" do
    describe '.alert' do
      after do
        @alert.dismissWithClickedButtonIndex(@alert.cancelButtonIndex, animated: false)

        wait 0.3 do
        end
      end

      describe "with only one string argument" do
        before do
          @alert = App.alert('1.21 Gigawatts!')
        end

        it 'returns an alert' do
          @alert.class.should == BW::UIAlertView
        end

        it 'is displaying the correct title' do
          @alert.title.should == '1.21 Gigawatts!'
        end

        describe 'cancelButton' do
          it 'is present' do
            @alert.cancelButtonIndex.should == 0
          end

          it 'has the correct title' do
            @alert.buttonTitleAtIndex(@alert.cancelButtonIndex).should == 'OK'
          end
        end
      end

      describe "with only two string arguments" do
        before do
          @alert = App.alert('1.21 Gigawatts!', 'Great Scott!')
        end

        it 'returns an alert' do
          @alert.class.should == BW::UIAlertView
        end

        it 'is displaying the correct title' do
          @alert.title.should == '1.21 Gigawatts!'
        end

        describe 'cancelButton' do
          it 'is present' do
            @alert.cancelButtonIndex.should == 0
          end

          it 'has the correct title' do
            @alert.buttonTitleAtIndex(@alert.cancelButtonIndex).should == 'Great Scott!'
          end
        end
      end

      describe "with variable args" do
        before do
          @alert = App.alert('1.21 Gigawatts!', cancel_button_title: 'Great Scott!',
                                                    message: 'Some random message')
        end

        it 'returns an alert' do
          @alert.class.should == BW::UIAlertView
        end

        it 'is displaying the correct title' do
          @alert.title.should == '1.21 Gigawatts!'
        end

        it 'is displaying the correct message' do
          @alert.message.should == 'Some random message'
        end

        describe 'cancelButton' do
          it 'is present' do
            @alert.cancelButtonIndex.should == 0
          end

          it 'has the correct title' do
            @alert.buttonTitleAtIndex(@alert.cancelButtonIndex).should == 'Great Scott!'
          end
        end
      end

      describe "with a block" do
        before do
          @alert = App.alert('1.21 Gigawatts!') do |alert|
            alert.message = 'My message!!'
          end
        end

        it 'returns an alert' do
          @alert.class.should == BW::UIAlertView
        end

        it 'is displaying the correct title' do
          @alert.title.should == '1.21 Gigawatts!'
        end

        it 'is displaying the correct message' do
          @alert.message.should == 'My message!!'
        end

        describe 'cancelButton' do
          it 'is present' do
            @alert.cancelButtonIndex.should == 0
          end

          it 'has the correct title' do
            @alert.buttonTitleAtIndex(@alert.cancelButtonIndex).should == 'OK'
          end
        end
      end
    end

    describe '.frame' do
      it 'returns Application Frame' do
        App.frame.should == UIScreen.mainScreen.applicationFrame
      end
    end

    describe '.bounds' do
      it 'returns Main Screen bounds' do
        App.bounds.should == UIScreen.mainScreen.bounds
      end
    end


    describe '.delegate' do
      it 'returns a TestSuiteDelegate' do
        App.delegate.should == UIApplication.sharedApplication.delegate
      end
    end

    describe '.shared' do
      it 'returns UIApplication.sharedApplication' do
        App.shared.should == UIApplication.sharedApplication
      end
    end

    describe '.windows' do
      it 'returns UIApplication.sharedApplication.windows' do
        App.windows.should == UIApplication.sharedApplication.windows
      end
    end

    describe '.window' do
      it 'returns UIApplication.sharedApplication.keyWindow' do
        App.window.class.should == UIApplication.sharedApplication.keyWindow.superclass
      end

      describe 'with UIActionSheet' do

        it 'returns the correct window' do
          action_sheet = UIActionSheet.alloc.init
          action_sheet.cancelButtonIndex = (action_sheet.addButtonWithTitle("Cancel"))

          old_window = App.window
          window_count = App.windows.count
          action_sheet.showInView(App.window)
          wait 1 do
            UIApplication.sharedApplication.windows.count.should > window_count
            App.window.should == old_window

            action_sheet.dismissWithClickedButtonIndex(action_sheet.cancelButtonIndex, animated: false)

            App.window.should == old_window
          end
        end
      end
    end

    describe '.run_after' do
      class DelayedRunAfterTest; attr_accessor :test_value end

      it 'should run a block after the provided delay' do
        @test_obj = DelayedRunAfterTest.new

        App.run_after(0.1){ @test_obj.test_value = true }
        wait_for_change(@test_obj, 'test_value') do
          @test_obj.test_value.should == true
        end
      end

    end

    describe ".open_url" do

      it "uses NSURL or converts NSString in NSURL and opens it" do
        application = UIApplication.sharedApplication
        def application.url; @url end
        def application.openURL(url); @url = url end

        url = NSURL.URLWithString('http://localhost')
        App.open_url(url)
        application.url.should.equal url

        url = 'http://localhost'
        App.open_url(url)
        application.url.class.should.equal NSURL
        application.url.description.should.equal url
      end

    end

    describe ".can_open_url" do

      it "uses NSURL or converts NSString in NSURL and opens it" do
        application = UIApplication.sharedApplication
        def application.url; @url end
        def application.canOpenURL(url); @url = url; super; end

        url = NSURL.URLWithString('http://localhost')
        App.can_open_url(url)
        application.url.should.equal url

        url = 'http://localhost'
        App.can_open_url(url)
        application.url.class.should.equal NSURL
        application.url.description.should.equal url
      end

      it "returns false when it can't open the given url" do
        App.can_open_url("inexistent_schema://").should.equal false
      end

      it "returns true when it can open the given url" do
        App.can_open_url("http://google.com").should.equal true
        App.can_open_url("rdar:").should.equal true
      end
    end
  end
end
