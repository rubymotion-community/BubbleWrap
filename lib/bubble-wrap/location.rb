require 'bubble-wrap/loader'
BubbleWrap.require('motion/util/constants.rb')
BubbleWrap.require('motion/core/string.rb')
BubbleWrap.require('motion/location/**/*.rb') do
  file('motion/location/pollute.rb').depends_on 'motion/location/location.rb'
  file('motion/location/location.rb').depends_on 'motion/util/constants.rb'
  file('motion/location/location.rb').uses_framework('CoreLocation')
end