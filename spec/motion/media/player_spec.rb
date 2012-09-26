describe BubbleWrap::Media::Player do
  describe ".play" do
    before do
      @player = BW::Media::Player.new
      @local_file = NSURL.fileURLWithPath(File.join(App.resources_path, 'test.mp3'))
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

  describe ".play_modal" do
    before do
      @player = BW::Media::Player.new
      @local_file = NSURL.fileURLWithPath(File.join(App.resources_path, 'test.mp3'))
    end

    it "should present a modalViewController on root if no controller given" do
      @controller = App.window.rootViewController

      @player.play_modal(@local_file)

      wait 1 do
        @controller.modalViewController.should.not == nil

        @player.stop
        wait 1 do
          @controller.modalViewController.should == nil
          @controller = nil
          @player = nil
        end
      end
    end

    it "should present a modalViewController if controller given" do
      @controller = UIViewController.alloc.initWithNibName(nil, bundle:nil)

      # .presentMoviePlayerViewControllerAnimated detects whether or not
      # @controller.view is part of a hierarchy, I guess. if you remove this
      # then the test fails.
      App.window.rootViewController.view.addSubview(@controller.view)

      @player.play_modal(@local_file, controller: @controller)

      wait 1 do
        @controller.modalViewController.should.not == nil

        @player.stop
        wait 1 do
          @controller.modalViewController.should == nil
          @controller = nil
          @player = nil
        end
      end
    end
  end
end