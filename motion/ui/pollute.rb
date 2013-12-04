# Please, no more!  It'll hurt BubbleWrap's compatibility with other libraries.
[
  [UIControl,         BW::UIControlWrapper],
  [UIView,            BW::UIViewWrapper],
  [UIViewController,  BW::UIViewControllerWrapper],
].each do |base, wrapper|
    base.send(:include, wrapper)
end
