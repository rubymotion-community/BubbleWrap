[
  [NSIndexPath, NSIndexPathWrap],
  [CLLocation, BW::CLLocationWrap],
].each do |base, wrapper|
    base.send(:include, wrapper)
end
