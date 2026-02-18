module RapidlyBuilt
  module Request
    module Middleware
      class Entry
        attr_accessor :context

        with_options to: :context do
          delegate :console
          delegate :ui
          delegate :controller
        end

        with_options to: :ui do
          delegate :layout
        end

        with_options to: :console do
          delegate :helpers
        end
      end
    end
  end
end
