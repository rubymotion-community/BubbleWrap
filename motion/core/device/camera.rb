# Provides a nice DSL for interacting with the standard
# UIImagePickerController
#
module BubbleWrap
  module Device
    class Camera
      module Error
        SOURCE_TYPE_NOT_AVAILABLE=0
        INVALID_MEDIA_TYPE=1
        MEDIA_TYPE_NOT_AVAILABLE=2
        INVALID_CAMERA_LOCATION=3
        CANCELED=1000
      end

      MEDIA_TYPE_HASH = {movie: KUTTypeMovie, image: KUTTypeImage}

      # The camera location; if :none, then we can't use source_type: :camera
      # in #picture
      # [:front, :rear, :none]
      attr_accessor :location

      def self.front
        return nil if not UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDeviceFront)
        Camera.new(:front)
      end

      def self.rear
        return nil if not UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDeviceRear)
        Camera.new(:rear)
      end

      # For uploading photos from the library.
      def self.any
        Camera.new
      end

      def initialize(location = :none)
        self.location = location
      end

      def location=(location)
        if not [:front, :rear, :none].member? location
          raise Error::INVALID_CAMERA_LOCATION, "#{location} is not a valid camera location"
        end
        @location = location
      end

      # @param [Hash] options to open the UIImagePickerController with 
      # the form {
      #   source_type: :photo_library, :camera, or :saved_photos_album; default :photo_library
      #   media_types: [] containing :image and/or :movie; default [:image]
      #   allows_editing: true/false; default false
      #   animated: true/false; default true
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
        @options[:media_types] = [:image] if not @options.has_key? :media_types

        # If we're using Camera.any, by default use photo library
        if not @options.has_key?(:source_type) && self.location == :none
          @options[:source_type] = :photo_library
        # If we're using a real Camera, by default use the camera.
        elsif not @options.has_key?(:source_type)
          @options[:source_type] = :camera
        end

        source_type = const_int_get("UIImagePickerControllerSourceType", @options[:source_type])
        if not Camera.source_type_available?(source_type)
          error(Error::SOURCE_TYPE_NOT_AVAILABLE) and return
        end

        media_types = @options[:media_types].collect { |mt| symbol_to_media_type(mt) }
        if media_types.member? nil
          error(Error::INVALID_MEDIA_TYPE) and return
        end

        media_types.each { |media_type|
          if not Camera.media_type_available?(media_type, for_source_type: source_type)
            error(Error::MEDIA_TYPE_NOT_AVAILABLE) and return
          end
        }

        @picker = UIImagePickerController.alloc.init
        @picker.delegate = self
        @picker.sourceType = source_type
        @picker.mediaTypes = media_types
        @picker.allowsEditing = @options[:allows_editing]

        if source_type == :camera && ![:front, :rear].member?(self.location)
          raise Error::INVALID_CAMERA_LOCATION, "Can't use camera location #{self.location} with source type :camera"
        end

        if source_type == :camera
          @picker.cameraDevice = const_int_get("UIImagePickerControllerCameraDevice", self.location)
        end

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
      def picker
        @picker
      end

      def dismiss
        @picker.dismissViewControllerAnimated(@options[:animated], completion: lambda {})
      end

      # @param [UIImagePickerControllerSourceType] source_type to check
      def self.source_type_available?(source_type)
        UIImagePickerController.isSourceTypeAvailable(source_type)
      end

      # @param [String] (either KUTTypeMovie or KUTTypeImage)
      # @param [UIImagePickerControllerSourceType]
      def self.media_type_available?(media_type, for_source_type: source_type)
        UIImagePickerController.availableMediaTypesForSourceType(source_type).member? media_type
      end

      private
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
        return value if value.is_a? Numeric
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
end
::Camera = BubbleWrap::Device::Camera