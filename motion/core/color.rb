class UIColor

	def self.color_with_hex ( hex_color )		
		hex_color = hex_color.gsub("#", "")		
		case hex_color.size 
      	when 3
        	colors = hex_color.scan(%r{[0-9A-Fa-f]}).map{ |el| (el * 2).to_i(16) }
      	when 6
        	colors = hex_color.scan(%r<[0-9A-Fa-f]{2}>).map{ |el| el.to_i(16) }        
        else
        	raise ArgumentError
        end	
        if colors.size == 3
        	UIColor.colorWithRed((colors[0]/255.0), green:(colors[1]/255.0), blue:(colors[2]/255.0), alpha:1)
        else
        	raise ArgumentError
        end	
	end

	
		
end	