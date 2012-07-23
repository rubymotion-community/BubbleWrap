require 'bubble-wrap/loader'
BubbleWrap.require('motion/core/string.rb')
BubbleWrap.require('motion/core/ns_notification_center.rb')
BubbleWrap.require('motion/media/**/*.rb') do
  file('motion/media/media.rb').depends_on('motion/media/player.rb')
  file('motion/media/player.rb').depends_on 'motion/core/string.rb'
  file('motion/media/player.rb').uses_framework('MediaPlayer')
end