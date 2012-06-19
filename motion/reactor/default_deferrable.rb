module BubbleWrap
  module Reactor
    # A basic class which includes Deferrable when all
    # you need is a deferrable without any added behaviour.
    class DefaultDeferrable
      include ::BubbleWrap::Reactor::Deferrable
    end
  end
end
