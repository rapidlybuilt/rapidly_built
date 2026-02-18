module RapidlyBuilt
  module Request
    class Container
      attr_reader :console

      def initialize(console: nil)
        @console = console
      end

      def middleware
        @middleware ||= Support::Middleware::ContextStack.new(console:)
      end
    end
  end
end
