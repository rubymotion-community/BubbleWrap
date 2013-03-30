require 'bubble-wrap/loader'
BW.require 'motion/wrappers/**/*.rb' do
  file('motion/wrappers/alert.rb').depends_on 'motion/wrappers/native_attributes.rb'
end