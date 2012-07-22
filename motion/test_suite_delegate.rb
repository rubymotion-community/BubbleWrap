class TestSuiteDelegate
  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = UIViewController.alloc.init
    @window.makeKeyAndVisible
    true
  end
end
