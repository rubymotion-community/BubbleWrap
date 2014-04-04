require 'bubble-wrap/version' unless defined?(BubbleWrap::VERSION)
require 'bubble-wrap/loader'
require 'bubble-wrap/network-indicator'
require 'bubble-wrap-http'
Motion::Project::App.info "Warning", "BubbleWrap::HTTP is deprecated and will be removed - switch to a different networking library soon (see https://github.com/rubymotion/BubbleWrap/issues/308)."
Motion::Project::App.info "Warning", "You can use the 'bubble-wrap-http' gem if you need compatibility: https://github.com/rubymotion/BubbleWrap-HTTP"