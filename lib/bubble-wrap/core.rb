BubbleWrap.require('motion/core.rb')
BubbleWrap.require('motion/core/**/*.rb') do 
  file('motion/core/device/screen.rb').depends_on 'motion/core/device.rb'
  file('motion/core/pollute.rb').depends_on 'motion/core/ns_index_path.rb'
  file('motion/core/pollute.rb').depends_on 'motion/core/ui_control.rb'
end
