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
      end
    end
  end
end
