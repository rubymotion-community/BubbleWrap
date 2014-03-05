describe BubbleWrap::Constants do
  describe ".get" do
    BubbleWrap::Constants.register NSStringEncodingConversionAllowLossy, NSStringEncodingConversionExternalRepresentation


    it "should return integer passed" do
      BW::Constants.get("anything", 5).should == 5
    end

    it "should return integer for decimal passed" do
      BW::Constants.get("anything", 5.0).should == 5
    end

    it "should return the correct integer for a string" do
      BW::Constants.get("NSStringEncodingConversion", "allow_lossy").should == NSStringEncodingConversionAllowLossy
    end

    it "should return the correct integer for a symbol" do
      BW::Constants.get("NSStringEncodingConversion", :allow_lossy).should == NSStringEncodingConversionAllowLossy
    end

    it "should bitmask array values" do
      BW::Constants.get("NSStringEncodingConversion", :allow_lossy, :external_representation).should == (NSStringEncodingConversionAllowLossy | NSStringEncodingConversionExternalRepresentation)
    end

    if App.ios?
      it "should return an array of string constant values" do
        BW::Constants.get("UIActivityType", [:air_drop, :print]).should == ["com.apple.UIKit.activity.AirDrop", "com.apple.UIKit.activity.Print"]
      end
    end

  end
end
