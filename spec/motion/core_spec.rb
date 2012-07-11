describe 'BubbleWrap' do


  describe "debug flag" do

    after do
       BubbleWrap.debug = false
    end

    it "can be set" do
      BubbleWrap.debug = true
      BubbleWrap.debug?.should.equal true
    end

    it "can be unset" do
      BubbleWrap.debug = false
      BubbleWrap.debug?.should.equal false
    end

  end

  describe "RGB color" do

    before do
      @red = 23
      @green = 45
      @blue = 12
    end

    it "creates color with rgb devided by 255 with alpha=1" do
      color = UIColor.colorWithRed((@red/255.0), green:(@green/255.0), blue:(@blue/255.0), alpha:1)
      BubbleWrap::rgb_color(@red, @green, @blue).should.equal color
    end

    it "rgba_color uses the real alpha" do
      alpha = 0.4
      color = UIColor.colorWithRed((@red/255.0), green:(@green/255.0), blue:(@blue/255.0), alpha:alpha)
      BubbleWrap::rgba_color(@red, @green, @blue, alpha).should.equal color
    end

  end

  describe "Localized string" do
    
    it "loads the string from NSBundle" do
      key = 'fake_key'
      value = 'fake_value'

      bundle = NSBundle.mainBundle
      def bundle.arguments; @arguments; end
      def bundle.localizedStringForKey(key, value:value, table:table); @arguments = [key, value, table]; end
      
      BubbleWrap::localized_string(key, value)
      bundle.arguments.should.equal [key, value, nil]
    end

  end
  
  describe "uuid" do

    it "creates always the new UUID" do
      previous = BW.create_uuid  
      10.times do
        uuid = BW.create_uuid
        uuid.should.not.equal previous
        uuid.size.should.equal 36
        previous = uuid
      end
    end

  end

end
