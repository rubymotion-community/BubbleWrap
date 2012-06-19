require 'bubble-wrap/loader'

BW.require 'motion/reactor.rb'
BW.require 'motion/reactor/**/*.rb' do
  file('motion/reactor.rb').depends_on Dir.glob('motion/reactor/**/*.rb')
  file('motion/reactor/timer.rb').depends_on 'motion/reactor/eventable.rb'
  file('motion/reactor/periodic_timer.rb').depends_on 'motion/reactor/eventable.rb'
  file('motion/reactor/deferrable.rb').depends_on ['motion/reactor/timer.rb', 'motion/reactor/future.rb']
  file('motion/reactor/default_deferrable.rb').depends_on 'motion/reactor/deferrable.rb'
end
