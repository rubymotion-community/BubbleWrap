[
  [UIControl, UIControlWrap]
].each do |base, wrapper|
    base.send(:include, wrapper)
end
