[
  [NSIndexPath, NSIndexPathWrap],
  [UIButton, UIButtonWrap]
].each do |base, wrapper|
  base.send(:include, wrapper)
end
