module RapidlyBuilt
  module Layout
    # Base class for layout middleware
    #
    # Layout middleware receives a Context and can add, modify, or configure the layout structure.
    # Each middleware must implement `#call(context)` and return the context.
    #
    # @example
    #   class MyLayoutMiddleware < RapidlyBuilt::Layout::Middleware
    #     def call(context)
    #       context.layout.header.build_icon_link("hash", routes.root_path, title: "My Gem")
    #       context
    #     end
    #   end
    #
    # Middleware can be initialized with URL helpers from a Rails engine:
    #   MyLayoutMiddleware.new(url_helpers: MyGem::Engine.routes.url_helpers)
    class Middleware
      attr_reader :url_helpers

      # @param url_helpers [Module] Optional URL helpers module from a Rails engine
      def initialize(url_helpers: nil)
        @url_helpers = url_helpers
      end

      # Process the layout context
      #
      # @param context [Context] The layout context
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
