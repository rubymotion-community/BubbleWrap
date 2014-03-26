describe BubbleWrap::Media::Player do
  describe ".play" do
    before do
      @player = BW::Media::Player.new
      @local_file = NSURL.fileURLWithPath(File.join(BW::App.resources_path, 'test.mp3'))
    end

    it "should raise error if not modal and no callback given" do
      should.raise(BW::Media::Error::NilPlayerCallback) do
        @player.play(@local_file)
      end
    end

    it "should yield to a block if not modal" do
      @did_yield = false
      @player.play(@local_file) do |_player|
        @did_yield = true
      end

      @did_yield.should == true
      @player.stop
    end

    it "should use the MPMoviePlayerController option overrides" do
      @player.play(@local_file, allows_air_play: true) do |_player|
        @did_yield = true
      end
      @player.media_player.allowsAirPlay.should == true
    end
  end

=begin
  describe ".play_modal" do
    before do
      @player = BW::Media::Player.new
      @local_file = NSURL.fileURLWithPath(File.join(BW::App.resources_path, 'test.mp3'))
    end

    it "should present a modalViewController on root if no controller given" do
      @controller = BW::App.window.rootViewController

      @player.play_modal(@local_file)


      EM.add_timer 2.0 do
        resume
      end
      wait_max 5 do
        @controller.modalViewController.should.not == nil
        EM.add_timer 4.0 do
          resume
        end

        @player.stop
        wait_max 5 do
          @controller.modalViewController.should == nil
          @controller = nil
          @player = nil
        end
      end
    end

    it "should present a modalViewController if controller given" do
      parent = BW::App.window.rootViewController
      @controller = UINavigationController.alloc.init
      parent.addChildViewController @controller
      @controller.viewWillAppear(false)
      parent.view.addSubview(@controller.view)
      @controller.viewDidAppear(false)

      @controller.didMoveToParentViewController(parent)

      EM.add_timer 3.0 do
        resume
      end
      wait_max 5 do
        @player.play_modal(@local_file, controller: @controller)
        @controller.modalViewController.should.not == nil
        EM.add_timer 2.0 do
          @player.stop
        end
        EM.add_timer 4.0 do
          resume
        end

        wait_max 5 do
          @controller.modalViewController.should == nil
          @controller.willMoveToParentViewController(nil)
          @controller.viewWillDisappear(false)
          @controller.removeFromParentViewController
          @controller.viewDidDisappear(false)
          @controller = nil
          @player = nil
        end
      end
    end
  end
=end
end
