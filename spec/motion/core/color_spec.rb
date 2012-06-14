describe "UIColor" do

	before do
      @blue_color = UIColor.blueColor
      @orange_color = UIColor.colorWithRed((255.0/255.0), green:(138.0/255.0), blue:(25.0/255.0), alpha:1.0)

    end

	describe "A UIColor should be created from a hex color" do


		it "with 6 digits" do
			@orange_color_from_hex= UIColor.color_with_hex('#FF8A19')
			@orange_color_from_hex.should == @orange_color		
		end	

		it "with 3 digits" do	
			@blue_color_from_hex = UIColor.color_with_hex('#00F')
			@blue_color_from_hex.should ==  @blue_color		
		end	

		it "with no # sign" do	
			@orange_color_from_hex= UIColor.color_with_hex('FF8A19')
			@orange_color_from_hex.should == @orange_color		
		end	
	end	

	describe "A UIColor should not be created from" do


		it "an invalid hex color" do
			should.raise( ArgumentError ) {
				UIColor.color_with_hex('XXX')	
			}			
		end
		
		it "a hex color with the wrong number of digits" do
			should.raise( ArgumentError ) {
				UIColor.color_with_hex('FFFF')	
			}			
		end

		
	end	
end