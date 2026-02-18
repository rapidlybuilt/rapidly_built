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
        attr_accessor :engine

        with_options to: :context do
          delegate :query_string
          delegate :results
          delegate :console
          delegate :add_result
        end

        with_options to: :context do
          delegate :ui
          delegate :controller
        end

        with_options to: :controller do
          delegate :request
        end

        def helpers
          @helpers ||= (engine || Rails.application).routes.url_helpers
        end
      end
    end
  end
end
