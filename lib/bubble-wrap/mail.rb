require 'bubble-wrap/loader'

BubbleWrap.require_ios("mail") do
  BubbleWrap.require('motion/core/app.rb')
  BubbleWrap.require('motion/mail/**/*.rb') do
    file('motion/mail/mail.rb').depends_on('motion/mail/result.rb')
    file('motion/mail/mail.rb').uses_framework('MessageUI')
  end
end
