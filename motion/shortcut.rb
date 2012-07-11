# Make sure that 
# Both BubbleWrap and BW are defined.  This file is depended on by everything
# else in BubbleWrap, so don't stuff anything in here unless you know why
# you're doing it.
module BubbleWrap
  SETTINGS = {}

  def self.debug=(val)
    BubbleWrap::SETTINGS[:debug] = val
  end

  def self.debug?
    BubbleWrap::SETTINGS[:debug]
  end

end

BW = BubbleWrap unless defined?(BW)
