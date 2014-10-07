module BW
  # New additions to CLAuthorizationStatus in ios8
  # see: https://developer.apple.com/library/prerelease/ios/documentation/CoreLocation/Reference/CLLocationManager_Class/index.html#//apple_ref/c/tdef/CLAuthorizationStatus
  Constants.register(
    KCLAuthorizationStatusAuthorizedWhenInUse,
    KCLAuthorizationStatusAuthorizedAlways
  )

  module Location
    def authorized?
      [
        BW::Constants.get("KCLAuthorizationStatus", :authorized),
        BW::Constants.get("KCLAuthorizationStatus", :authorized_always),
        BW::Constants.get("KCLAuthorizationStatus", :authorized_when_in_use)
      ].include?(CLLocationManager.authorizationStatus)
    end
  end
end
