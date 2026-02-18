module RapidlyBuilt
  module Console
    module RoutesExt
      def console(id, &)
        # Yield the block within a namespace block
        namespace(id, defaults: { console_id: id }) do
          get "search/index", to: "/rapidly_built/searches#index"
          get "search", to: "/rapidly_built/searches#show"

          yield
        end
      end
    end
  end
end
