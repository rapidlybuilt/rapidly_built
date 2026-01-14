module RapidlyBuilt
  module Toolkit
    # Toolkit that brings together tools and their middleware stacks
    #
    # Each toolkit manages:
    # - A list of tools
    # - A search middleware stack
    # - A setup middleware stack
    #
    # @example
    #   toolkit = RapidlyBuilt::Toolkit.new
    #   toolkit.add_tool(MyGem::Tool.new)
    #   toolkit.search_middleware.use(MySearchMiddleware)
    #   toolkit.context_middleware.use(MySetupMiddleware)
    class Base
      attr_reader :id
      attr_reader :tools
      attr_reader :context_middleware
      attr_reader :search_middleware

      def initialize(id)
        @id = id
        @tools = []
        @search_middleware = Middleware.new
        @context_middleware = Middleware.new
        @mounted = false
      end

      # Check if this toolkit's tools have been mounted in a Rails engine
      #
      # @return [Boolean] true if the toolkit has been mounted
      def mounted?
        @mounted
      end

      # Mark this toolkit as mounted
      # Called automatically when the engine's routes block runs
      #
      # @return [self]
      def mark_as_mounted!
        @mounted = true
        self
      end

      # Add a tool to the toolkit and call its connect method
      #
      # @param tool [Base] The tool instance to add
      # @return [self]
      # @raise [RuntimeError] if the toolkit has already been mounted
      def add_tool(tool)
        if mounted?
          raise RuntimeError, "Cannot add tools to a toolkit that has already been mounted in a Rails engine"
        end

        @tools << tool
        tool.connect(self)
        self
      end

      def engine
        @engine ||= Rails::Engine.build_engine_for(self)
      end
    end
  end
end
