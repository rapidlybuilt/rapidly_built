module RapidlyBuilt
  # Application that brings together plugins and their middleware stacks
  #
  # Each application manages:
  # - A list of plugins
  # - A search middleware stack
  # - A layout middleware stack
  #
  # @example
  #   app = RapidlyBuilt::Application.new
  #   app.add_plugin(MyGem::Plugin.new)
  #   app.search_middleware.use(MySearchMiddleware)
  #   app.layout_middleware.use(MyLayoutMiddleware)
  class Application
    attr_reader :plugins, :search_middleware, :layout_middleware

    def initialize
      @plugins = []
      @search_middleware = Middleware.new
      @layout_middleware = Middleware.new
      @mounted = false
    end

    # Check if this application's plugins have been mounted in a Rails engine
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

    # Add a plugin to the application and call its connect method
    #
    # @param plugin [Base] The plugin instance to add
    # @return [self]
    # @raise [RuntimeError] if the application has already been mounted
    def add_plugin(plugin)
      if mounted?
        raise RuntimeError, "Cannot add plugins to an application that has already been mounted in a Rails engine"
      end

      @plugins << plugin
      plugin.connect(self)
      self
    end
  end
end
