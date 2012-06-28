# Make sure that 
# Both BubbleWrap and BW are defined.  This file is depended on by everything
# else in BubbleWrap, so don't stuff anything in here unless you know why
# you're doing it.
module BubbleWrap
end
BW = BubbleWrap unless defined?(BW)
