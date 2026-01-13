module RapidlyBuilt
  module Layout
    # Context object that flows through the layout middleware stack
    #
    # Contains both the layout being modified and the application instance.
    # Each layout middleware receives a Context and can modify the layout.
    #
    # @example
    #   context = RapidlyBuilt::Layout::Context.new(layout: layout, application: app)
    #   context.layout # => ApplicationLayout instance
    #   context.application # => RapidlyBuilt::Application instance
    class Context
      attr_reader :layout, :application

      # @param layout [ApplicationLayout] The layout instance being modified
      # @param application [RapidlyBuilt::Application] The application instance
      def initialize(layout:, application:)
        @layout = layout
        @application = application
      end
    end
  end
end
