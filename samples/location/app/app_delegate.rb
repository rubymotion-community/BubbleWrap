class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    places_list_controller = PlacesListController.alloc.init
    @window.rootViewController = places_list_controller
    @window.makeKeyAndVisible
  end
end
