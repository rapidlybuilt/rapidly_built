module RapidlyBuilt
  module Layout
    # Context object that flows through the layout middleware stack
    #
    # Contains both the layout being modified and the toolkit instance.
    # Each layout middleware receives a Context and can modify the layout.
    #
    # @example
    #   context = RapidlyBuilt::Layout::Context.new(layout: layout, toolkit: toolkit)
    #   context.layout # => ApplicationLayout instance
    #   context.toolkit # => RapidlyBuilt::Toolkit instance
    class Context
      attr_reader :layout, :toolkit

      # @param layout [ApplicationLayout] The layout instance being modified
      # @param toolkit [RapidlyBuilt::Toolkit] The toolkit instance
      def initialize(layout:, toolkit:)
        @layout = layout
        @toolkit = toolkit
      end
    end
  end
end
