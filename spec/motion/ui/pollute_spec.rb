describe "UIKit pollution" do
  it "pollutes UIControl" do
    UIControl.ancestors.should.include BW::UIControlWrapper
  end

  it "pollutes UIView" do
    UIView.ancestors.should.include BW::UIViewWrapper
  end

  it "pollutes UIViewController" do
    UIViewController.ancestors.should.include BW::UIViewControllerWrapper
  end
end
