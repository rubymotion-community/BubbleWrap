require 'bubble-wrap/loader'

BubbleWrap.require_ios("network-indicator") do
  BubbleWrap.require('motion/core/app.rb')
  BubbleWrap.require('motion/network-indicator/**/*.rb') do
    # file('motion/network-indicator/network-indicator.rb').depends_on('motion/network-indicator/result.rb')
  end
end
