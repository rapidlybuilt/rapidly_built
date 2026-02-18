module Inventory
  class Integration < RapidlyBuilt::Integration::Base
    def call
      search.index.add_result(
        title: "Inventory",
        url: helpers.root_path,
        description: "Manage inventory"
      )

      search.index.add_result(
        title: "Inventory Items",
        url: helpers.items_path,
        description: "Manage inventory"
      )

      request.middleware.use RequestMiddleware
      search.middleware.use SearchMiddleware
    end

    class RequestMiddleware < RapidlyBuilt::Request::Middleware::Entry
      def call
        layout.header.right.build_text_link("Inventory", helpers.items_path)
      end
    end

    class SearchMiddleware < RapidlyBuilt::Search::Middleware::Entry
      def call
        Item.search(query_string).each do |item|
          add_result(
            title: item.name,
            url: helpers.item_path(item),
            description: item.description
          )
        end
      end
    end
  end
end
