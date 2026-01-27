module RapidlyBuilt
  module Search
    # Container for search functionality providing both static and dynamic search
    #
    # Static search items are searched client-side for instant results.
    # Dynamic search middleware runs server-side for query-dependent results.
    #
    # @example
    #   toolkit.search.static.add(title: "Button", url: "/components/button")
    #   toolkit.search.dynamic.use(MySearchMiddleware)
    class Container
      # Access the static search index
      #
      # @return [Static] The static search index
      def static
        @static ||= Static.new
      end

      # Access the dynamic search middleware stack
      #
      # @return [Toolkit::Middleware] The middleware stack for dynamic search
      def dynamic
        @dynamic ||= Toolkit::Middleware.new
      end
    end
  end
end
