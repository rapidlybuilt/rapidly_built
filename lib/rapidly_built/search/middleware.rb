module RapidlyBuilt
  module Search
    # Middleware module that provides a stack of Rack-like middleware for extendable
    # search functionality.
    module Middleware
      # Base middleware class that provides a context for the middleware
      #
      # @example
      #   class MyMiddleware < RapidlyBuilt::Search::Middleware::Entry
      #     def call
      #       # do something
      #     end
      #   end
      class Entry
        attr_accessor :context

        with_options to: :context do
          delegate :query_string
          delegate :results
          delegate :console
          delegate :add_result
        end

        with_options to: :console do
          delegate :helpers
        end
      end
    end
  end
end
