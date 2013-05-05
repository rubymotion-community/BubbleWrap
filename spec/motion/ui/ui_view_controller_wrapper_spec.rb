describe BW::UIViewControllerWrapper do
  describe "#content_frame" do
    describe "given a UIViewController" do
      before do
        @subject = UIViewController.alloc.init
      end

      it "has the correct content frame" do
        height   = App.frame.size.height
        expected = CGRectMake(0, 0, App.frame.size.width, height)

        @subject.content_frame.should.equal(expected)
      end
    end

    ###############################################################################################

    describe "given a UIViewController inside a UINavigationController" do
      before do
        @subject = UIViewController.alloc.init

        UINavigationController.alloc.initWithRootViewController(@subject)
      end

      it "has the correct content frame" do
        height   = App.frame.size.height
        height   -= @subject.navigationController.navigationBar.frame.size.height
        expected = CGRectMake(0, 0, App.frame.size.width, height)

        @subject.content_frame.should.equal(expected)
      end
    end
  end
end
