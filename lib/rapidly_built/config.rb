module RapidlyBuilt
  # Configuration class for managing RapidlyBuilt applications
  #
  # @example
  #   RapidlyBuilt.config do |config|
  #     config.build_application :admin, tools: [MyAdmin::Tool, AnotherAdmin::Tool]
  #     config.build_application :root, tools: [MyRoot::Tool, AnotherRoot::Tool]
  #   end
  class Config
    def initialize
      @applications = {}
      @engines = {}
    end

    # Build an application with the given name and tools
    #
    # @param name [Symbol, String] The name of the application
    # @param tools [Array<Class>] Array of tool classes to instantiate and add
    # @return [Application] The created application
    def build_application(name, tools: [])
      name = name.to_sym

      app = Application.new
      tools.each do |tool_class|
        app.add_tool(tool_class.new)
      end

      @applications[name] = app
      @engines[name] = Rails::Engine.build_engine_for(app) if defined?(::Rails::Engine)

      app
    end

    # Get the default application, creating it if it doesn't exist
    #
    # @return [Application] The default application instance
    def default_application
      @applications[:default] ||= Application.new
    end

    # Get an application by name
    #
    # @param name [Symbol, String, nil] The application name, or nil for default
    # @return [Application, nil] The application instance, or nil if not found
    def application(name = nil)
      if name.nil? || name == :default
        default_application
      else
        @applications[name.to_sym] || raise(ApplicationNotFoundError, "Application #{name.inspect} not found")
      end
    end

    # Get all applications
    #
    # @return [Hash] Hash of application name to Application instance
    def applications
      @applications.dup
    end

    # Get the engine class for a specific application
    #
    # @param name [Symbol, String, nil] The application name, or nil for default
    # @return [Class] The engine class for the application
    def engine(name = nil)
      if name.nil? || name == :default
        Rails::Engine
      else
        @engines[name.to_sym] || raise(ApplicationNotFoundError, "Application #{name.inspect} for engine not found")
      end
    end
  end
end
