module BubbleWrap
  module Dispatch
    # A basic class which includes Deferrable when all
    # you need is a deferrable without any added behaviour.
    class DefaultDeferrable
      include ::BubbleWrap::Dispatch::Deferrable
    end
  end
end
