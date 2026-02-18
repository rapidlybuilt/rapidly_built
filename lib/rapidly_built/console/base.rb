module RapidlyBuilt
  module Console
    class Base
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
        helpers.send("#{id}_search_index_path", **kwargs)
      end

      def search_path(**kwargs)
        helpers.send("#{id}_search_path", **kwargs)
      end

      private

      def integrate(my_module, *args, engine: nil, **kwargs)
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

      class State
        attr_accessor :engine
      end
    end
  end
end
