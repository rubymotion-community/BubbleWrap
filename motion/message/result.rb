module BubbleWrap
  module Message
    class Result
      attr_accessor :result

      def initialize(result)
        self.result = result
      end

      def sent?
        self.result == MessageComposeResultSent
      end

      def canceled?
        self.result == MessageComposeResultCancelled
      end

      def failed?
        self.result == MessageComposeResultFailed
      end
      
    end
  end
end
