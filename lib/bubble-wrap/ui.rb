require 'bubble-wrap/loader'

BubbleWrap.require_ios("ui") do
  BubbleWrap.require('motion/util/constants.rb')
  BubbleWrap.require('motion/ios/7/uiactivity_view_controller_constants.rb') if App.config.send(:deployment_target).to_f >= 7.0
  BubbleWrap.require('motion/ui/**/*.rb') do
    file('motion/ui/pollute.rb').depends_on %w(
      motion/ui/ui_control_wrapper.rb
      motion/ui/ui_view_wrapper.rb
      motion/ui/ui_view_controller_wrapper.rb
    )
  end
end
