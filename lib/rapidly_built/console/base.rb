module RapidlyBuilt
  module Console
    class Base
      class_attribute :search_index_path, instance_accessor: false
      class_attribute :search_path, instance_accessor: false

      attr_accessor :id

      def initialize(id:)
        @id = id
        @current_state = State.new
      end

      def modules
        @modules ||= []
      end

      def request
        @request ||= Request::Container.new(current_state: @current_state)
      end

      def search
        @search ||= Search::Container.new(current_state: @current_state)
      end

      def helpers
        Rails.application.routes.url_helpers
      end

      def search_index_path(**kwargs)
        helpers.send(self.class.search_index_path || "#{id}_search_index_path", **kwargs)
      end

      def search_path(**kwargs)
        helpers.send(self.class.search_path || "#{id}_search_path", **kwargs)
      end

      private

      def integrate(my_module, *args, engine: detect_engine(my_module), **kwargs)
        modules << [ my_module, args, kwargs ]

        @current_state.engine = engine

        integration_class = "#{my_module}/integration".camelize.constantize
        integration = integration_class.new(*args, **kwargs, engine:, console: self)
        integration.console = self
        integration.call
        integration
      ensure
        @current_state.engine = nil
      end

      def detect_engine(my_module)
        return nil unless my_module.respond_to?(:railtie_namespace)
        my_module.railtie_namespace
      end

      class State
        attr_accessor :engine
      end
    end
  end
end
