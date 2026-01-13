module RapidlyBuilt
  module Search
    # Base class for search middleware
    #
    # Search middleware receives a Context and can add, modify, or filter results.
    # Each middleware must implement `#call(context)` and return the context.
    #
    # @example
    #   class MySearchMiddleware < RapidlyBuilt::Search::Middleware
    #     def call(context)
    #       # Use the engine's path helpers
    #       context.add_result(
    #         title: "My Result",
    #         url: routes.root_path,
    #         description: "A result from my middleware"
    #       )
    #       context
    #     end
    #   end
    #
    # Middleware can be initialized with URL helpers from a Rails engine:
    #   MySearchMiddleware.new(url_helpers: MyGem::Engine.routes.url_helpers)
    class Middleware
      attr_reader :url_helpers

      # @param url_helpers [Module] Optional URL helpers module from a Rails engine
      def initialize(url_helpers: nil)
        @url_helpers = url_helpers
      end

      # Process the search context
      #
      # @param context [Context] The search context
      # @return [Context] The modified context
      def call(context)
        raise NotImplementedError, "#{self.class} must implement #call"
      end

      # Access URL helpers for path generation
      #
      # @return [Module, nil] The URL helpers module from the middleware's engine
      def routes
        url_helpers
      end
    end
  end
end
