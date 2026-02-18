module RapidlyBuilt
  module Request
    class Container
      def middleware
        @middleware ||= Support::Middleware::ContextStack.new
      end
    end
  end
end
