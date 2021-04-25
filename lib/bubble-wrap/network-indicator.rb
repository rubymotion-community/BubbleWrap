require 'bubble-wrap/loader'

BubbleWrap.require_xos("network-indicator") do
  BubbleWrap.require('motion/core/app.rb')
  BubbleWrap.require('motion/network-indicator/**/*.rb')
end
