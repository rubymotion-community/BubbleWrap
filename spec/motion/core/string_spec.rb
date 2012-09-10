describe BubbleWrap::String do

  describe ::String do
    it 'should include BubbleWrap::String' do
      ::String.ancestors.member?(BubbleWrap::String).should == true
    end
  end

  describe 'CamelCase input' do
    describe '.camelize(true)' do
      it "doesn't change the value" do
        'CamelCase'.camelize(true).should == 'CamelCase'
      end
    end

    describe '.camelize(false)' do
      it 'lower cases the first character' do
        'CamelCase'.camelize(false).should == 'camelCase'
      end
    end

    describe '.camelize(:upper)' do
      it "doesn't change the value" do
        'CamelCase'.camelize(:upper).should == 'CamelCase'
      end
    end

    describe '.camelize(:lower)' do
      it 'lower cases the first character' do
        'CamelCase'.camelize(:lower).should == 'camelCase'
      end
    end

    describe '.underscore' do
      it 'converts it to underscores' do
        'CamelCase'.underscore.should == 'camel_case'
      end
    end
  end

  describe 'camelCase input' do
    describe '.camelize(true)' do
      it "upper cases the first character" do 
        'camelCase'.camelize(true).should == 'CamelCase'
      end
    end

    describe '.camelize(false)' do
      it "doesn't change the value" do
        'camelCase'.camelize(false).should == 'camelCase'
      end
    end

    describe '.camelize(:upper)' do
      it "upper cases the first character" do
        'camelCase'.camelize(:upper).should == 'CamelCase'
      end
    end

    describe '.camelize(:lower)' do
      it "doesn't change the value" do
        'camelCase'.camelize(:lower).should == 'camelCase'
      end
    end

    describe '.underscore' do
      it 'converts it to underscores' do
        'camelCase'.underscore.should == 'camel_case'
      end
    end
  end

  describe 'snake_case input' do
    describe '.camelize(true)' do
      it 'converts to CamelCase' do
        'snake_case'.camelize(true).should == 'SnakeCase'
      end
    end

    describe '.camelize(false)' do
      it 'converts to camelCase' do
        'snake_case'.camelize(false).should == 'snakeCase'
      end
    end

    describe '.underscore' do
      it "doesn't change the value" do
        'snake_case'.underscore.should == 'snake_case'
      end
    end

  end

  before do
    @blue_color = UIColor.blueColor
    @orange_color = UIColor.colorWithRed((255.0/255.0), green:(138.0/255.0), blue:(25.0/255.0), alpha:1.0)
  end

  describe "A UIColor should be created from a String with a hex color" do

    it "with 6 digits" do
      @orange_color_from_hex= '#FF8A19'.to_color
      @orange_color_from_hex.should == @orange_color    
    end 

    it "with 3 digits" do 
      @blue_color_from_hex = '#00F'.to_color
      @blue_color_from_hex.should ==  @blue_color   
    end 

    it "with no # sign" do  
      @orange_color_from_hex= 'FF8A19'.to_color
      @orange_color_from_hex.should == @orange_color    
    end 
  end 

  describe "a string with a color keyword (blue, red, lightText)" do
    it "should return the corresponding color" do
      'blue'.to_color.should == UIColor.blueColor
    end

    it "should accept camelCase" do
      'lightText'.to_color.should == UIColor.lightTextColor
    end

    it "should accept snake_case" do
      'dark_gray'.to_color.should == UIColor.darkGrayColor
    end
  end

  describe "A UIColor should not be created from an invalid String" do

    it "an invalid hex color" do
      should.raise( ArgumentError ) {
        'XXX'.to_color
      }     
    end
    
    it "a hex color with the wrong number of digits" do
      should.raise( ArgumentError ) {
        'FFFF'.to_color
      }     
    end
    
  end 

  describe "encoding" do

    before do
      @raw_string = "hey ho let's {go}"
    end

    it "to_url_encoded" do
      real_encoded = @raw_string.stringByAddingPercentEscapesUsingEncoding NSUTF8StringEncoding
      @raw_string.to_url_encoded.should.equal real_encoded
    end

    it "handles other encodings" do
      utf16 = @raw_string.stringByAddingPercentEscapesUsingEncoding NSUTF16StringEncoding
      @raw_string.to_url_encoded(NSUTF16StringEncoding).should.equal utf16
    end

    it "to_url_decoded" do
      encoded_string = "hey%20ho%20let's%20%7Bgo%7D"
      real_decoded = encoded_string.stringByReplacingPercentEscapesUsingEncoding NSUTF8StringEncoding
      
      encoded_string.to_url_decoded.should.equal real_decoded
    end


    describe "dataUsingEncoding" do

      it "#to_url_encoded_data - utf8" do
        utf8 = @raw_string.dataUsingEncoding NSUTF8StringEncoding
        @raw_string.to_encoded_data.should.equal utf8
      end
      
      it "handles multiple encodings" do
        utf16 = @raw_string.dataUsingEncoding NSUTF16StringEncoding
        @raw_string.to_encoded_data(NSUTF16StringEncoding).should.equal utf16
      end

    end


  end

end
