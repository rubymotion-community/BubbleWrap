describe BubbleWrap::Constants do
  describe ".get" do
    BubbleWrap::Constants.register UIReturnKeyDone, UIReturnKeyNext


    it "should return integer passed" do
      BW::Constants.get("anything", 5).should == 5
    end

    it "should return integer for decimal passed" do
      BW::Constants.get("anything", 5.0).should == 5
    end

    it "should return the correct integer for a string" do
      BW::Constants.get("UIReturnKey", "done").should == UIReturnKeyDone
    end

    it "should return the correct integer for a symbol" do
      BW::Constants.get("UIReturnKey", :done).should == UIReturnKeyDone
    end

    it "should bitmask array values" do
      BW::Constants.get("UIReturnKey", :done, :next).should == (UIReturnKeyDone | UIReturnKeyNext)
    end
  end
end
