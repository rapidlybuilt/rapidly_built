module RapidlyBuilt
  module Request
    module Middleware
      class Entry
        attr_accessor :context
        attr_accessor :engine

        with_options to: :context do
          delegate :console
          delegate :ui
          delegate :controller
        end

        with_options to: :ui do
          delegate :layout
        end

        def helpers
          @helpers ||= (engine || Rails.application).routes.url_helpers
        end
      end
    end
  end
end
