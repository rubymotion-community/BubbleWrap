module BubbleWrap
  module Reactor
    class DependentDeferrable < DefaultDeferrable
      # args are Deferrable(s) which the returned Deferrable depends on.
      # returns a Deferrable that depends on args.
      # which:
      #   succeeds only when every Deferrable in args succeeds
      #   fails immediately when any Deferrable in args fails
      # Have to be careful that #deferred_args for DependentDeferrable is a list of #deferred_args from its children Deferrable(s).
      def self.on(*args)
        deferrable = self.new
        @children_deferrables = args
        @children_deferrables.each do |e|
          e.callback do |result|
            if @children_deferrables.all? {|a| a.deferred_status == :succeeded}
              deferrable.succeed(*@children_deferrables.map(&:deferred_args))
            end
          end
          e.errback do |result|
            deferrable.fail(*e.deferred_args)
          end
        end
        deferrable
      end
    end
  end
end
