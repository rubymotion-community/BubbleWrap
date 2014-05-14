module BW
  class UIActivityViewController < ::UIActivityViewController
    class << self
      def new(options = {}, presenting_controller = nil, &block)
        options = {
          activities: nil,
          animated: true
        }.merge(options)

        if options[:item] || options[:items]
          items = Array(options[:item] || options[:items])
        else
          raise ArgumentError, "You must specify at least one item - #{options.inspect}"
        end

        vc = alloc.initWithActivityItems(items, applicationActivities:options[:activities])
        vc.excludedActivityTypes = BW::Constants.get("UIActivityType", Array(options[:excluded])) if options[:excluded]

        unless block.nil?
          block.weak! if BubbleWrap.use_weak_callbacks?
          vc.setCompletionHandler block
        end

        presenting_controller ||= App.window.rootViewController.presentedViewController # May be nil, but handles use case of container views
        presenting_controller ||= App.window.rootViewController

        presenting_controller.presentViewController(vc, animated:options[:animated], completion: lambda {})
        vc
      end

    end
  end

  # UIActivityTypes
  Constants.register(
    UIActivityTypePostToFacebook,
    UIActivityTypePostToTwitter,
    UIActivityTypePostToWeibo,
    UIActivityTypeMessage,
    UIActivityTypeMail,
    UIActivityTypePrint,
    UIActivityTypeCopyToPasteboard,
    UIActivityTypeAssignToContact,
    UIActivityTypeSaveToCameraRoll
  )

  # These constants are not iOS 6 compatable.
  # Define them but don't initialize them unless we're on iOS 7
  if defined?(UIActivityViewController::UIActivityTypeAddToReadingList).nil?
    Kernel.const_set('UIActivityTypeAddToReadingList', '')
    Kernel.const_set('UIActivityTypePostToFlickr', '')
    Kernel.const_set('UIActivityTypePostToVimeo', '')
    Kernel.const_set('UIActivityTypePostToTencentWeibo', '')
  end

  if Device.ios_version >= "7.0"
    Constants.register(
      Kernel.const_get('UIActivityTypeAddToReadingList'),
      Kernel.const_get('UIActivityTypePostToFlickr'),
      Kernel.const_get('UIActivityTypePostToVimeo'),
      Kernel.const_get('UIActivityTypePostToTencentWeibo'),
      Kernel.const_get('UIActivityTypeAirDrop')
    )
  end
end
