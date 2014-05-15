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
    UIActivityViewController.const_set('UIActivityTypeAddToReadingList', '')
    UIActivityViewController.const_set('UIActivityTypePostToFlickr', '')
    UIActivityViewController.const_set('UIActivityTypePostToVimeo', '')
    UIActivityViewController.const_set('UIActivityTypePostToTencentWeibo', '')
    UIActivityViewController.const_set('UIActivityTypeAirDrop', '')
  end

  if Device.ios_version >= "7.0"
    Constants.register(
      UIActivityViewController.const_get('UIActivityTypeAddToReadingList'),
      UIActivityViewController.const_get('UIActivityTypePostToFlickr'),
      UIActivityViewController.const_get('UIActivityTypePostToVimeo'),
      UIActivityViewController.const_get('UIActivityTypePostToTencentWeibo'),
      UIActivityViewController.const_get('UIActivityTypeAirDrop')
    )
  end
end
