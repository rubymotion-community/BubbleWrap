module BubbleWrap
  module Font
    module_function

    def bold(size = nil)
      Font.new(:bold, size)
    end

    def system(size = nil)
      Font.new(:system, size)
    end

    def italic(size = nil)
      Font.new(:italic, size)
    end

    # Example
    # Font.new(<# UIFont >)
    # Font.new("Helvetica")
    # Font.new("Helvetica", 12)
    # Font.new("Helvetica", size: 12)
    # Font.new(name: "Helvetica", size: 12)
    def new(params = {}, *args)
      if params.is_a?(UIFont)
        return params
      end
      _font = nil

      if params.is_a?(NSString)
        params = {name: params}
      end

      if args && !args.empty?
        case args[0]
        when NSDictionary
          params.merge!(args[0])
        else
          params.merge!({size: args[0]})
        end
      end
      params[:size] ||= UIFont.systemFontSize

      case params[:name].to_sym
      when :system
        _font = UIFont.systemFontOfSize(params[:size].to_f)
      when :bold
        _font = UIFont.boldSystemFontOfSize(params[:size].to_f)
      when :italic
        _font = UIFont.italicSystemFontOfSize(params[:size].to_f)
      else
        begin
          _font = UIFont.fontWithName(params[:name], size: params[:size])
        rescue
        end
      end

      if !_font
        raise "Invalid font for parameters: #{params.inspect} args #{args.inspect}"
      end

      _font
    end

    class << self
      alias_method :named, :new
    end

    # I.e. for UINavigationBar#titleTextAttributes
    def attributes(params = {})
      _attributes = {}

      _attributes[UITextAttributeFont] = Font.new(params[:font]) if params[:font]
      _attributes[UITextAttributeTextColor] = params[:color].to_color if params[:color]
      _attributes[UITextAttributeTextShadowColor] = params[:shadow_color].to_color if params[:shadow_color]
      _attributes[UITextAttributeTextShadowOffset] = begin
        x = params[:shadow_offset][:x]
        y = params[:shadow_offset][:y]
        offset = UIOffsetMake(x,y)
        NSValue.valueWithUIOffset(offset)
      end if params[:shadow_offset]

      _attributes
    end
  end
end