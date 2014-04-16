require 'bubble-wrap/version' unless defined?(BubbleWrap::VERSION)
require 'bubble-wrap/loader'
require 'bubble-wrap/network-indicator'
require 'bubble-wrap-http'
Motion::Project::App.warn "BubbleWrap::HTTP is deprecated and will be removed, see https://github.com/rubymotion/BubbleWrap/issues/308"
Motion::Project::App.warn "Switch to a different networking library soon - consider AFNetworking: http://afnetworking.com/"
Motion::Project::App.warn "You can use the 'bubble-wrap-http' gem if you need compatibility: https://github.com/rubymotion/BubbleWrap-HTTP"