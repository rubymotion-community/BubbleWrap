module BW
  class UIActivityViewController < ::UIActivityViewController
    # iOS 7 ONLY Constants for UIActivityViewController
    Constants.register(
      UIActivityTypeAddToReadingList,
      UIActivityTypePostToFlickr,
      UIActivityTypePostToVimeo,
      UIActivityTypePostToTencentWeibo,
      UIActivityTypeAirDrop
    )
end
