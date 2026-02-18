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
        @request ||= Request::Container.new
      end

      def search
        @search ||= Search::Container.new
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

      def integrate(my_module, *args, **kwargs)
        modules << [my_module, args, kwargs]

        integration_class = "#{my_module}/integration".camelize.constantize
        integration = integration_class.new(*args, **kwargs)
        integration.console = self
        integration.call
        integration
      end
    end
  end
end
