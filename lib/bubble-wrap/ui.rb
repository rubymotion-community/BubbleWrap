require 'bubble-wrap/loader'

BubbleWrap.require_ios("ui") do
  BubbleWrap.require('motion/util/constants.rb')
  BubbleWrap.require('motion/ui/**/*.rb') do
    file('motion/ui/pollute.rb').depends_on %w(
      motion/ui/ui_control_wrapper.rb
      motion/ui/ui_view_wrapper.rb
      motion/ui/ui_view_controller_wrapper.rb
    )
  end
end
