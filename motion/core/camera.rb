# Provides a nice DSL for interacting with the standard
# UIImagePickerController
#
module BubbleWrap
  module Camera
    module Error
      SOURCE_TYPE_NOT_AVAILABLE=0
      INVALID_MEDIA_TYPE=1
      MEDIA_TYPE_NOT_AVAILABLE=2
      CANCELED=1000
    end

    MEDIA_TYPE_HASH = {movie: KUTTypeMovie, image: KUTTypeImage}

    module_function

    # @param [Hash] options to open the UIImagePickerController with 
    # the form {
    #   source_type: :photo_library, :camera, or :saved_photos_album,
    #   media_types: [] containing :image and/or :movie,
    #   allows_editing: true/false,
    #   animated: true/false
    # }
    # 
    # @param [UIViewController] view controller from which to present the image picker;
    #   if nil, uses the keyWindow's rootViewController.
    # 
    # @block for callback. takes one argument.
    #   - On error or cancelled, is called with a hash {error: BW::Camera::Error::<Type>}
    #   - On success, is called with a hash with a possible set of keys
    #   [:media_type, :original_image, :edited_image, :crop_rect, :media_url,
    #    :reference_url, :media_metadata]
    #
    # Example
    # BW::Camera.picture(source_type: :photo_library, media_types: [:image]) do |result|
    #   image_view = UIImageView.alloc.initWithImage(result[:original_image])
    # end
    def picture(options = {}, presenting_controller = nil, &block)
      @callback = block

      @options = options
      @options[:allows_editing] = false if not @options.has_key? :allows_editing
      @options[:animated] = true if not @options.has_key? :animated

      source_type = const_int_get("UIImagePickerControllerSourceType", @options[:source_type])
      if not source_type_available?(source_type)
        error(Error::SOURCE_TYPE_NOT_AVAILABLE) and return
      end

      media_types = @options[:media_types].collect { |mt| symbol_to_media_type(mt) }
      if media_types.member? nil
        error(Error::INVALID_MEDIA_TYPE) and return
      end

      media_types.each { |media_type|
        if not media_type_available?(media_type, for_source_type: source_type)
          error(Error::MEDIA_TYPE_NOT_AVAILABLE) and return
        end
      }

      @picker = UIImagePickerController.alloc.init
      @picker.delegate = self
      @picker.sourceType = source_type
      @picker.mediaTypes = media_types
      @picker.allowsEditing = @options[:allows_editing]

      presenting_controller ||= UIApplication.sharedApplication.keyWindow.rootViewController
      presenting_controller.presentViewController(@picker, animated:@options[:animated], completion: lambda {})
    end

    ##########
    # UIImagePickerControllerDelegate Methods
    def imagePickerControllerDidCancel(picker)
      error(Error::CANCELED)
      dismiss
    end

    # Takes the default didFinishPickingMediaWithInfo hash,
    # transforms the keys to be nicer symbols of :this_form
    # instead of UIImagePickerControllerThisForm, and then sends it
    # to the callback
    def imagePickerController(picker, didFinishPickingMediaWithInfo: info)
      delete_keys = []
      callback_info = {}

      info.keys.each { |k|
        nice_key = k.gsub("UIImagePickerController", "").underscore.to_sym
        val = info[k]
        callback_info[nice_key] = val
        info.delete k
      }

      if media_type = callback_info[:media_type]
        callback_info[:media_type] = media_type_to_symbol(media_type)
      end

      @callback.call(callback_info)
      dismiss
    end

    ##########
    # Short Helper Methods

    # @param [UIImagePickerControllerSourceType] source_type to check
    def source_type_available?(source_type)
      UIImagePickerController.isSourceTypeAvailable(source_type)
    end

    # @param [String] (either KUTTypeMovie or KUTTypeImage)
    # @param [UIImagePickerControllerSourceType]
    def media_type_available?(media_type, for_source_type: source_type)
      UIImagePickerController.availableMediaTypesForSourceType(source_type).member? media_type
    end

    def picker
      @picker
    end

    def dismiss
      @picker.dismissViewControllerAnimated(@options[:animated], completion: lambda {})
    end

    # ex media_type_to_symbol(KUTTypeMovie) => :movie
    def media_type_to_symbol(media_type)
      MEDIA_TYPE_HASH.invert[media_type]
    end

    # ex symbol_to_media_type(:movie) => :KUTTypeMovie
    def symbol_to_media_type(symbol)
      MEDIA_TYPE_HASH[symbol]
    end

    def error(type)
      @callback.call({ error: type })
    end

    # @param [String] base of the constant 
    # @param [Integer, String, Symbol] the 
    # @return [Integer] the constant for this base
    # Examples
    # const_int_get("UIReturnKey", :done) => UIReturnKeyDone == 9
    # const_int_get("UIReturnKey", "done") => UIReturnKeyDone == 9
    # const_int_get("UIReturnKey", 9) => 9
    def const_int_get(base, value)
      return value if value.is_a? Integer
      value = value.to_s.camelize
      Kernel.const_get("#{base}#{value}")
    end

    # Looks like RubyMotion adds UIKit constants
    # at compile time. If you don't use these
    # directly in your code, they don't get added
    # to Kernel and const_int_get crashes.
    def load_constants_hack
      [UIImagePickerControllerSourceTypePhotoLibrary, UIImagePickerControllerSourceTypeCamera, 
        UIImagePickerControllerSourceTypeSavedPhotosAlbum
      ]
    end
  end
end
::Camera = BubbleWrap::Camera