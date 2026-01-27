module RapidlyBuilt
  # Configuration class for managing RapidlyBuilt toolkits
  #
  # @example
  #   RapidlyBuilt.config do |config|
  #     config.build_toolkit :admin, tools: [MyAdmin::Tool, AnotherAdmin::Tool]
  #     config.build_toolkit :root, tools: [MyRoot::Tool, AnotherRoot::Tool]
  #   end
  class Config
    # Whether to reload middleware classes on each call.
    #
    # When true, middleware instances are created fresh on each call,
    # allowing code changes to take effect without restarting.
    # When false, instances are cached for performance.
    #
    # Defaults to false. The Rails railtie sets this to true in development.
    #
    # @return [Boolean]
    attr_accessor :reload_classes
    alias_method :reload_classes?, :reload_classes

    def initialize
      @toolkits = {}
      @reload_classes = false
    end

    # Build a toolkit with the given name and tools
    #
    # @param name [Symbol, String] The name of the toolkit
    # @param tools [Array<Class>] Array of tool classes to instantiate and add
    # @return [Toolkit] The created toolkit
    def build_toolkit(name, tools: [], **options)
      name = name.to_sym

      klass = options[:class] || Toolkit::Base
      toolkit = klass.new(name)
      tools.each do |tool|
        tool = tool.new if tool.is_a?(Class)
        toolkit.add_tool(tool)
      end

      @toolkits[name] = toolkit
      toolkit
    end

    # Get the default toolkit, creating it if it doesn't exist
    #
    # @return [Toolkit] The default toolkit instance
    def default_toolkit
      @toolkits[:default] ||= build_toolkit(:default)
    end

    # Define an engine for the default toolkit
    #
    # @return [Class] The engine class
    def default_engine
      default_toolkit.engine
    end

    # Get a toolkit by name
    #
    # @param name [Symbol, String, nil] The toolkit name, or nil for default
    # @return [Toolkit, nil] The toolkit instance, or nil if not found
    def find_toolkit!(name = nil)
      if name.nil? || name == :default
        default_toolkit
      else
        @toolkits[name.to_sym] || raise(ToolkitNotFoundError, "Toolkit #{name.inspect} not found")
      end
    end

    # Get all toolkits
    #
    # @return [Hash] Hash of toolkit name to Toolkit instance
    def toolkits
      @toolkits.dup
    end

    # Get the engine class for a specific toolkit
    #
    # @param name [Symbol, String, nil] The toolkit name, or nil for default
    # @return [Class] The engine class for the toolkit
    def engine(name = nil)
      find_toolkit!(name).engine
    end
  end
end
