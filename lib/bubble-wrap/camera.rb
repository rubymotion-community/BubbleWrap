require 'bubble-wrap/loader'
BubbleWrap.require('motion/util/constants.rb')
BubbleWrap.require('motion/core/device.rb')
BubbleWrap.require('motion/core/device/**/*.rb') do
  file('motion/core/device/camera_wrapper.rb').depends_on 'motion/core/device/camera.rb'
  file('motion/core/device/camera.rb').depends_on ['motion/core/device.rb', 'motion/util/constants.rb']
  file('motion/core/device/screen.rb').depends_on 'motion/core/device.rb'
end