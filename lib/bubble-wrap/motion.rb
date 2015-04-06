require 'bubble-wrap/loader'

BubbleWrap.require_ios('motion') do
  BubbleWrap.require('motion/util/constants.rb')
  BubbleWrap.require('motion/core/string.rb')
  BubbleWrap.require('motion/motion/**/*.rb') do
    file('motion/motion/motion.rb').depends_on 'motion/util/constants.rb'

    file('motion/motion/accelerometer.rb').depends_on('motion/motion/motion.rb')
    file('motion/motion/device_motion.rb').depends_on('motion/motion/motion.rb')
    file('motion/motion/gyroscope.rb').depends_on('motion/motion/motion.rb')
    file('motion/motion/magnetometer.rb').depends_on('motion/motion/motion.rb')

    file('motion/motion/motion.rb').uses_framework('CoreMotion')
  end
end
