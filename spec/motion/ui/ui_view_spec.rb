describe "UIView" do

  describe "Building an object" do
    
    it "should build UI element" do
      label = UILabel.build
      label.class.should == UILabel
    end

  end

end