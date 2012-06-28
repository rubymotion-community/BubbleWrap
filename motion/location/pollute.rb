[
  [CLLocation, BubbleWrap::CLLocationWrap],
].each do |base, wrapper|
    base.send(:include, wrapper)
end
