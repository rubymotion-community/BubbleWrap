require 'bubble-wrap/loader'

BubbleWrap.require_ios("message") do
  BubbleWrap.require('motion/core/app.rb')
  BubbleWrap.require('motion/message/**/*.rb') do
    file('motion/message/message.rb').depends_on('motion/message/result.rb')
    file('motion/message/message.rb').uses_framework('MessageUI')
  end
end
