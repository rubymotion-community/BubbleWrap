require 'bubble-wrap/loader'

BubbleWrap.require_ios("sms") do
  BubbleWrap.require('motion/core/app.rb')
  BubbleWrap.require('motion/sms/**/*.rb') do
    file('motion/sms/sms.rb').depends_on('motion/sms/result.rb')
    file('motion/sms/sms.rb').uses_framework('MessageUI')
  end
end
