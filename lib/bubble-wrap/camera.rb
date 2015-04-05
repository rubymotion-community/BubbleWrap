require 'bubble-wrap/loader'

BubbleWrap.require_ios("camera") do
  BubbleWrap.require('motion/util/constants.rb')
  BubbleWrap.require('motion/core/device.rb')
  BubbleWrap.require('motion/core/device/*.rb')
  BubbleWrap.require('motion/core/device/ios/*.rb') do
    file('motion/core/device/ios/camera_wrapper.rb').depends_on 'motion/core/device/ios/camera.rb'
    file('motion/core/device/ios/camera.rb').depends_on ['motion/core/ios/device.rb', 'motion/util/constants.rb']
    file('motion/core/device/ios/screen.rb').depends_on 'motion/core/ios/device.rb'
  end
end
