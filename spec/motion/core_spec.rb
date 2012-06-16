describe 'BubbleWrap' do

  describe "RGB color"do

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


  


end
