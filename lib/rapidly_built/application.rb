module RapidlyBuilt
  # Application that brings together tools and their middleware stacks
  #
  # Each application manages:
  # - A list of tools
  # - A search middleware stack
  # - A layout middleware stack
  #
  # @example
  #   app = RapidlyBuilt::Application.new
  #   app.add_tool(MyGem::Tool.new)
  #   app.search_middleware.use(MySearchMiddleware)
  #   app.layout_middleware.use(MyLayoutMiddleware)
  class Application
    attr_reader :tools, :search_middleware, :layout_middleware

    def initialize
      @tools = []
      @search_middleware = Middleware.new
      @layout_middleware = Middleware.new
      @mounted = false
    end

    # Check if this application's tools have been mounted in a Rails engine
    #
    # @return [Boolean] true if the application has been mounted
    def mounted?
      @mounted
    end

    # Mark this application as mounted
    # Called automatically when the engine's routes block runs
    #
    # @return [self]
    def mark_as_mounted!
      @mounted = true
      self
    end

    # Add a tool to the application and call its connect method
    #
    # @param tool [Base] The tool instance to add
    # @return [self]
    # @raise [RuntimeError] if the application has already been mounted
    def add_tool(tool)
      if mounted?
        raise RuntimeError, "Cannot add tools to an application that has already been mounted in a Rails engine"
      end

      @tools << tool
      tool.connect(self)
      self
    end
  end
end
