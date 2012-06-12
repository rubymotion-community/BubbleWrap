require 'bubble-wrap/loader'
require "bw-dispatch/version"

BW.require 'motion/dispatch/**/*.rb' do
  file('motion/dispatch.rb').uses_framework 'GCD'
  file('motion/dispatch.rb').depends_on Dir.glob('motion/dispatch/**/*.rb')
  file('motion/dispatch/timer.rb').depends_on 'motion/dispatch/eventable.rb'
  file('motion/dispatch/periodic_timer.rb').depends_on 'motion/dispatch/eventable.rb'
  file('motion/dispatch/deferrable.rb').depends_on ['motion/dispatch/timer.rb', 'motion/dispatch/future.rb']
  file('motion/dispatch/default_deferrable.rb').depends_on 'motion/dispatch/deferrable.rb'
end
