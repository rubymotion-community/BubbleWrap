class UIViewController
  # Short hand to get the content frame
  # 
  # Return content frame: the application frame - navigation bar frame
  def content_frame
    app_frame = App.frame
    navbar_height = self.navigationController.nil? ? 
      0 : self.navigationController.navigationBar.frame.size.height
    CGRectMake(0, 0, app_frame.size.width, app_frame.size.height - navbar_height)
  end
end