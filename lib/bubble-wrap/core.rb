require 'bubble-wrap/loader'

BubbleWrap.require('motion/core.rb')
BubbleWrap.require('motion/core/*.rb') do
  file('motion/core/pollute.rb').depends_on 'motion/core/ns_index_path.rb'
end
BubbleWrap.require('motion/core/device/*.rb')

BubbleWrap.require_ios do
  BubbleWrap.require('motion/core/ios/**/*.rb')
  BubbleWrap.require('motion/core/device/ios/**/*.rb')
end

BubbleWrap.require_osx do
  BubbleWrap.require('motion/core/osx/**/*.rb')
  BubbleWrap.require('motion/core/device/osx/**/*.rb')
end

require 'bubble-wrap/camera'
require 'bubble-wrap/ui'