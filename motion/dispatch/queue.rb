module BubbleWrap
  module Dispatch
    # A GCD scheduled, linear queue.
    #
    # This class provides a simple “Queue” like abstraction on top of the 
    # GCD scheduler. 
    #
    # Useful as an API sugar for stateful protocols
    #
    #  q = EM::Queue.new
    #  q.push('one', 'two', 'three')
    #  3.times do
    #    q.pop{ |msg| puts(msg) }
    #  end
    class Queue

      # Create a new queue
      # label:
      #   A label to attach to the queue to uniquely identify it in debugging 
      #   tools such as Instruments, sample, stackshots, and crash reports. 
      #   Because applications, libraries, and frameworks can all create their 
      #   own dispatch queues, a reverse-DNS naming style (com.example.myqueue) 
      #   is recommended. This parameter is optional and can be nil.
      def initialize(label=nil)
      end
    end
  end
end
