module RapidlyBuilt
  module Toolkit
    # Toolkit that brings together tools and their middleware stacks
    #
    # Each toolkit manages:
    # - A list of tools
    # - A search container (static items + dynamic middleware)
    # - A context middleware stack
    #
    # @example
    #   toolkit = RapidlyBuilt::Toolkit.new
    #   toolkit.add_tool(MyGem::Tool.new)
    #   toolkit.search.static.add(title: "Home", url: "/", description: "Homepage")
    #   toolkit.search.dynamic.use(MySearchMiddleware)
    #   toolkit.context_middleware.use(MySetupMiddleware)
    class Base
      attr_reader :id
      attr_reader :tools
      attr_reader :context_middleware
      attr_reader :search

      def initialize(id)
        @id = id
        @tools = []
        @search = Search::Container.new
        @context_middleware = Middleware.new
      end

      # Add a tool to the toolkit and call its connect method
      #
      # @param tool [Base] The tool instance to add
      # @return [self]
      # @raise [ToolNotUniqueError] if the tool already exists
      def add_tool(tool)
        if find_tool(tool.class, id: tool.id)
          raise ToolNotUniqueError, "Tool #{tool.class.name} with id #{tool.id.inspect} already exists"
        end

        @tools << tool
        tool.connect(self)
        self
      end

      # Find a tool by class and optional ID
      #
      # @param klass [Class] The tool class
      # @param id [String, nil] The ID of the tool
      # @return [Tool] The found tool
      # @raise [ToolNotFoundError] if the tool is not found
      def find_tool!(klass, id: nil)
        find_tool(klass, id: id) || raise(ToolNotFoundError, "Tool #{klass.name} with id #{id.inspect} not found")
      end

      # Find a tool by class and optional ID
      #
      # @param klass [Class] The tool class
      # @param id [String, nil] The ID of the tool
      # @return [Tool, nil] The found tool, or nil if not found
      def find_tool(klass, id: nil)
        @tools.find { |tool| tool.is_a?(klass) && tool.id == id }
      end
    end
  end
end
