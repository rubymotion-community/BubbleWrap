module BubbleWrap
  # This module contains convenience methods which are patched onto
  # NSString
  module String

    def bw_camelize(uppercase_first_letter = :upper)
      if [TrueClass, FalseClass].member? uppercase_first_letter.class
        _argument = uppercase_first_letter
        uppercase_first_letter = uppercase_first_letter ? :upper : :lower
        puts "[DEPRECATED] - String#camelize with `uppercase_first_letter` == #{_argument} " +
             "is deprecated; use :#{uppercase_first_letter} instead."
      end

      support_camelize(uppercase_first_letter)
    end

    def to_url_encoded(encoding = NSUTF8StringEncoding)
      stringByAddingPercentEscapesUsingEncoding encoding
    end

    def to_url_decoded(encoding = NSUTF8StringEncoding)
      stringByReplacingPercentEscapesUsingEncoding encoding
    end

    def to_encoded_data(encoding = NSUTF8StringEncoding)
      dataUsingEncoding encoding
    end

    def to_color
      # First check if it is a color keyword
      keyword_selector = "#{self.camelize(:lower)}Color"
      return UIColor.send(keyword_selector) if UIColor.respond_to? keyword_selector

      # Next attempt to convert from hex
      hex_color = self.gsub("#", "")   
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
end

String.send(:include, BubbleWrap::String)

String.send(:alias_method, :support_camelize, :camelize)
String.send(:alias_method, :camelize, :bw_camelize)
