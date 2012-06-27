require 'bubble-wrap/loader'
BubbleWrap.require('motion/core.rb')
BubbleWrap.require('motion/core/**/*.rb') do 
  file('motion/core/device/screen.rb').depends_on 'motion/core/device.rb'
  file('motion/core/pollute.rb').depends_on 'motion/core/ns_index_path.rb'
end
require 'bubble-wrap/ui'