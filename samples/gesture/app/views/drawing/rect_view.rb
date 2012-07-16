class RectView < GestureView
  def drawRect(rect)
    super(rect)

    context = UIGraphicsGetCurrentContext()
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    CGContextSetFillColorWithColor(context, UIColor.redColor.CGColor)
    CGContextSetLineWidth(context, 10.0)
    CGContextAddRect(context, [[0,0], [self.frame.size.width,self.frame.size.height]])
    CGContextFillPath(context)
  end
end