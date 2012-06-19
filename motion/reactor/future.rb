module BubbleWrap
  module Reactor
    module Future

      # A future is a sugaring of a typical deferrable usage.
      def future arg, cb=nil, eb=nil, &blk
        arg = arg.call if arg.respond_to?(:call)

        if arg.respond_to?(:set_deferred_status)
          if cb || eb
            arg.callback(&cb) if cb
            arg.errback(&eb) if eb
          else
            arg.callback(&blk) if blk
          end
        end

        arg
      end
    end
  end
end
