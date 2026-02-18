class AdminConsole < RapidlyBuilt::Console::Base
  def initialize(**kwargs)
    super(**kwargs)

    request.middleware.use RequestMiddleware

    integrate CustomerRelations
    integrate Inventory, engine: Inventory::Engine
  end

  private

  class RequestMiddleware < RapidlyBuilt::Request::Middleware::Entry
    def call
      ui.layout.build_header do |header|
        header.build_right do |right|
        end
      end
    end
  end
end
