class DrawingViewController < UIViewController
  attr_reader :drawing_view

  def loadView
    screen = UIScreen.mainScreen.bounds
    self.view = UIView.alloc.initWithFrame screen
    self.view.backgroundColor = UIColor.whiteColor

    @drawing_view = RectView.alloc.initWithFrame [[screen.size.width/2-50,screen.size.height/2-50], [100,100]]
    self.view.addSubview @drawing_view
  end
end