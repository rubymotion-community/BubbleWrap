class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    camera_controller = CameraController.alloc.init
    @window.rootViewController = camera_controller
    @window.makeKeyAndVisible
  end
end
