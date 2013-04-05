# Stupid hack because the RubyMotion dependency detection has a bug.
module Kernel.const_get("BubbleWrap")::Constants
  module_function

  # Looks like RubyMotiononly  adds UIKit constants
  # at compile time. If you don't use these
  # directly in your code, they don't get added
  # to Kernel and Constants.get crashes.
  # Examples
  # Constants.register UIReturnKeyDone, UIReturnKeyNext
  def register(*ui_constants)
    # do nothing, just get the constants in the code
  end

  # @param [String] base of the constant 
  # @param [Integer, NSArray, String, Symbol] the suffix of the constant
  #   when NSArray, will return the bitmask of all suffixes in the array
  # @return [Integer] the constant for this base and suffix
  # Examples
  # get("UIReturnKey", :done) => UIReturnKeyDone == 9
  # get("UIReturnKey", "done") => UIReturnKeyDone == 9
  # get("UIReturnKey", 9) => 9
  # get("UIImagePickerControllerSourceType", ["photo_library", "camera", "saved_photos_album"]) => 3
  def get(base, *values)
    value = values.size == 1 ? values.first : values.flatten
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