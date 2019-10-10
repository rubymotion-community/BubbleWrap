module BubbleWrap
  # This module contains simplified version of the `camelize` and
  # `underscore` methods from ActiveSupport, since these are such
  # common operations when dealing with the Cocoa API.
  module String

    # Convert 'snake_case' into 'CamelCase'
    def camelize(uppercase_first_letter = true)
      string = self.dup
      string.gsub!(/(?:_|(\/))([a-z\d]*)/i) do
        new_word = $2.downcase
        new_word[0] = new_word[0].upcase
        new_word = "/#{new_word}" if $1 == '/'
        new_word
      end
      if uppercase_first_letter && uppercase_first_letter != :lower
        string[0] = string[0].upcase
      else
        string[0] = string[0].downcase
      end
      string.gsub!('/', '::')
      string
    end

    # Convert 'CamelCase' into 'snake_case'
    def underscore
      word = self.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end

    def to_url_encoded(encoding = nil, legacy = false)
      if legacy
        stringByAddingPercentEscapesUsingEncoding(encoding || NSUTF8StringEncoding)
      else
        encoding ||= KCFStringEncodingUTF8
        encoding = CFStringConvertNSStringEncodingToEncoding(encoding) unless CFStringIsEncodingAvailable(encoding)
        CFURLCreateStringByAddingPercentEscapes(nil, self, nil, "!*'();:@&=+$,/?%#[]", encoding)
      end
    end

    def to_url_decoded(encoding = nil, legacy = false)
      if legacy
        stringByReplacingPercentEscapesUsingEncoding(encoding || NSUTF8StringEncoding)
      else
        if encoding
          encoding = CFStringConvertNSStringEncodingToEncoding(encoding) unless CFStringIsEncodingAvailable(encoding)
          CFURLCreateStringByReplacingPercentEscapesUsingEncoding(nil, self, nil, encoding)
        else
          CFURLCreateStringByReplacingPercentEscapes(nil, self, nil)
        end
      end
    end

    def to_encoded_data(encoding = NSUTF8StringEncoding)
      dataUsingEncoding encoding
    end

    def to_color
      # First check if it is a color keyword
      keyword_selector = "#{self.camelize(:lower)}Color"
      color_klass = App.osx? ? NSColor : UIColor
      return color_klass.send(keyword_selector) if color_klass.respond_to? keyword_selector

      # Next attempt to convert from hex
      hex_color = self.gsub("#", "")
      case hex_color.size
        when 3
          colors = hex_color.scan(%r{[0-9A-Fa-f]}).map!{ |el| (el * 2).to_i(16) }
        when 6
          colors = hex_color.scan(%r<[0-9A-Fa-f]{2}>).map!{ |el| el.to_i(16) }
        when 8
          colors = hex_color.scan(%r<[0-9A-Fa-f]{2}>).map!{ |el| el.to_i(16) }
        else
          raise ArgumentError
      end
      if colors.size == 3
        BubbleWrap.rgb_color(colors[0], colors[1], colors[2])
      elsif colors.size == 4
        BubbleWrap.rgba_color(colors[1], colors[2], colors[3], colors[0])
      else
        raise ArgumentError
      end
    end

  end
end

# Strange fix for https://github.com/rubymotion/BubbleWrap/issues/456
#
# Originally:
# NSString.send("include", BubbleWrap::String)

class NSString
  include BubbleWrap::String
end

