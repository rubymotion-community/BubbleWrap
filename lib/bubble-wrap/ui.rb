require 'bubble-wrap/loader'

BubbleWrap.require_ios("ui") do
  BubbleWrap.require('motion/ui/**/*.rb') do
    file('motion/ui/pollute.rb').depends_on 'motion/ui/ui_control.rb'
  end
end