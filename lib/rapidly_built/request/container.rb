module RapidlyBuilt
  module Request
    class Container
      attr_reader :current_state

      def initialize(current_state: nil)
        @current_state = current_state
      end

      def middleware
        @middleware ||= Support::Middleware::ContextStack.new(current_state:)
      end
    end
  end
end
