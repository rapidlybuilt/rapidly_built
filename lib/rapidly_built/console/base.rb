module RapidlyBuilt
  module Console
    class Base
      attr_accessor :id

      def initialize(id:)
        @id = id
      end

      def modules
        @modules ||= []
      end

      def request
        @request ||= Request::Container.new(console: self)
      end

      def search
        @search ||= Search::Container.new(console: self)
      end

      def helpers
        Rails.application.routes.url_helpers
      end

      def search_index_path(**kwargs)
        helpers.send("#{id}_search_index_path", **kwargs)
      end

      def search_path(**kwargs)
        helpers.send("#{id}_search_path", **kwargs)
      end

      private

      # HACK: track the engine for the current integration
      # so we can pass it down into the middleware (for url helpers)
      attr_accessor :current_engine

      def integrate(my_module, *args, engine: nil, **kwargs)
        modules << [ my_module, args, kwargs ]

        self.current_engine = engine

        integration_class = "#{my_module}/integration".camelize.constantize
        integration = integration_class.new(*args, **kwargs, engine:, console: self)
        integration.console = self
        integration.call
        integration
      ensure
        self.current_engine = nil
      end
    end
  end
end
