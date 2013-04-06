describe BubbleWrap::Font do
  [[:system, "systemFontOfSize:"], [:bold, "boldSystemFontOfSize:"], [:italic, "italicSystemFontOfSize:"]].each do |font, method|
    describe ".#{font}" do
      it "should work" do
        f = BubbleWrap::Font.send(font, 16)
        f.should == UIFont.send(method, 16)

        f = BubbleWrap::Font.send(font)
        f.should == UIFont.send(method, UIFont.systemFontSize)
      end
    end
  end

  describe ".make" do
    it "should work with UIFont" do
      BubbleWrap::Font.new(UIFont.boldSystemFontOfSize(12)).should == UIFont.boldSystemFontOfSize(12)
    end

    it "should work with string" do
      BubbleWrap::Font.new("Helvetica").should == UIFont.fontWithName("Helvetica", size: UIFont.systemFontSize)
    end

    it "should work with string and size" do
      BubbleWrap::Font.new("Helvetica", 18).should == UIFont.fontWithName("Helvetica", size: 18)
    end

    it "should work with string and hash" do
      BubbleWrap::Font.new("Helvetica", size: 16).should == UIFont.fontWithName("Helvetica", size: 16)
    end

    it "should work with hash" do
      BubbleWrap::Font.new(name: "Chalkduster", size: 16).should == UIFont.fontWithName("Chalkduster", size: 16)
    end
  end

  describe ".named" do
    it "should work" do
      BubbleWrap::Font.named("Helvetica").should == UIFont.fontWithName("Helvetica", size: UIFont.systemFontSize)
    end
  end

  describe ".attributes" do
    it "should work" do
      _attributes = BubbleWrap::Font.attributes(font: UIFont.systemFontOfSize(12), color: "red", shadow_color: "blue", shadow_offset: {x: 5, y: 10})

      _attributes.should == {
        UITextAttributeFont => UIFont.systemFontOfSize(12),
        UITextAttributeTextColor => UIColor.redColor,
        UITextAttributeTextShadowColor => UIColor.blueColor,
        UITextAttributeTextShadowOffset => NSValue.valueWithUIOffset(UIOffsetMake(5, 10))
      }
    end
  end
end