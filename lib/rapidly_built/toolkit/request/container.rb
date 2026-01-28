module RapidlyBuilt
  module Toolkit
    module Request
      class Container
        def middleware
          @middleware ||= Toolkit::Middleware.new
        end
      end
    end
  end
end
