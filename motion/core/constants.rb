module BubbleWrap
  module Constants
    module_function

    # @param [String] base of the constant 
    # @param [Integer, NSArray, String, Symbol] the suffix of the constant
    #   when NSArray, will return the bitmask of all suffixes in the array
    # @return [Integer] the constant for this base and suffix
    # Examples
    # get("UIReturnKey", :done) => UIReturnKeyDone == 9
    # get("UIReturnKey", "done") => UIReturnKeyDone == 9
    # get("UIReturnKey", 9) => 9
    # get("UIImagePickerControllerSourceType", ["photo_library", "camera", "saved_photos_album"]) => 3
    def get(base, value)
      case value
      when Numeric
        value.to_i
      when NSArray
        value.reduce { |i, j|
          get(base, i) | get(base, j)
        }
      else
        value = value.to_s.camelize
        Kernel.const_get("#{base}#{value}")
      end
    end
  end
end