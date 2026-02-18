module RapidlyBuilt
  module Search
    # Container for search functionality providing both static and dynamic search
    #
    # Static search items are searched client-side for instant results.
    # Dynamic search middleware runs server-side for query-dependent results.
    #
    # @example
    #   toolkit.search.index.add_result(title: "Button", url: "/components/button")
    #   toolkit.search.middleware.use(MySearchMiddleware)
    class Container
      attr_reader :current_state

      def initialize(current_state: nil)
        @current_state = current_state
      end

      # Access the static search index
      #
      # @return [Index] The static search index
      def index
        @index ||= Index.new
      end

      # Access the dynamic search middleware stack
      #
      # @return [Support::Middleware] The middleware stack for dynamic search
      def middleware
        @middleware ||= Support::Middleware::ContextStack.new(current_state:)
      end
    end
  end
end
