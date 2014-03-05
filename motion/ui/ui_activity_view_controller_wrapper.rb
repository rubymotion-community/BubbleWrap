module BW
  class UIActivityViewController < ::UIActivityViewController

    class << self
      def new(options = {}, presenting_controller = nil, &block)
        options = {
          activities: nil,
          transition: UIModalTransitionStyleCoverVertical,
          animated: true
        }.merge(options)

        if options[:item] || options[:items]
          items = Array(options[:item] || options[:items])
        else
          raise ArgumentError, "You must specify at least one item - #{options.inspect}"
        end

        vc = alloc.initWithActivityItems(items, applicationActivities:options[:activities])
        vc.setModalTransitionStyle options[:transition]
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
    UIActivityTypeSaveToCameraRoll,
    UIActivityTypeAddToReadingList,
    UIActivityTypePostToFlickr,
    UIActivityTypePostToVimeo,
    UIActivityTypePostToTencentWeibo,
    UIActivityTypeAirDrop
  )

  # Transition Styles
  Constants.register(
    UIModalTransitionStyleCoverVertical,
    UIModalTransitionStyleFlipHorizontal,
    UIModalTransitionStyleCrossDissolve,
    UIModalTransitionStylePartialCurl
  )
end
