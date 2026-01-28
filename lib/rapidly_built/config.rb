module RapidlyBuilt
  # Configuration class for managing RapidlyBuilt toolkits
  #
  # @example
  #   RapidlyBuilt.config do |config|
  #     config.toolkits.new :admin do |toolkit|
  #       toolkit.tools << MyAdmin::Tool
  #       toolkit.tools << AnotherAdmin::Tool
  #     end
  #
  #     config.toolkits.new :root, class_name: "MyApplicationToolkit" do |toolkit|
  #       toolkit.tools << MyRoot::Tool
  #       toolkit.tools << AnotherRoot::Tool
  #     end
  #   end
  class Config
    attr_reader :toolkits

    def initialize
      @toolkits = Toolkits.new
    end

    # Manages toolkit configurations and lazy instantiation
    #
    # Configurations are stored at boot time, instances are built
    # on first access (after Rails autoloading is complete).
    class Toolkits
      def initialize
        @configs = {}
        @instances = {}
      end

      # Clear cached instances to force rebuild on next access.
      # Called by the Rails engine's to_prepare hook in development.
      def reload!
        @instances = {}
      end

      # Define a new toolkit configuration
      #
      # @param id [Symbol, String] The toolkit identifier
      # @param class_name [String, nil] Optional custom toolkit class name (for lazy loading)
      # @yield [RapidlyBuilt::Toolkit::Base] The toolkit instance (where the block is lazy-executed)
      def new(id, class_name: nil, &block)
        id = id.to_sym
        raise ToolkitAlreadyDefinedError, "Toolkit #{id.inspect} already defined" if @configs[id]

        config = Toolkit.new(id, class_name: class_name)
        config.blocks << block if block
        @configs[id] = config
        nil
      end

      # Configure an existing toolkit configuration
      #
      # @param id [Symbol, String] The toolkit identifier
      # @yield [RapidlyBuilt::Toolkit::Base] The toolkit instance (where the block is lazy-executed)
      def configure(id, &block)
        config = @configs[id]
        raise ToolkitNotFoundError, "Toolkit #{id.inspect} not found" unless config
        config.blocks << block if block
        nil
      end

      # Find or build a toolkit instance by name
      #
      # @param id [Symbol, String, nil] The toolkit identifier, or nil for default
      # @return [Toolkit::Base] The toolkit instance
      # @raise [ToolkitNotFoundError] if no configuration exists for the given id
      def find!(id)
        id = id.to_sym
        @instances[id] ||= build(id)
      end

      private

      # Build a toolkit instance from its configuration
      #
      # @param id [Symbol] The toolkit identifier
      # @return [Toolkit::Base] The built toolkit instance
      # @raise [ToolkitNotFoundError] if no configuration exists
      def build(id)
        config = @configs[id]
        raise ToolkitNotFoundError, "Toolkit #{id.inspect} not found" unless config

        # Resolve toolkit class (supports lazy loading via string class names)
        klass = if config.class_name
          config.class_name.constantize
        else
          RapidlyBuilt::Toolkit::Base
        end

        toolkit = klass.new

        # Add tools (supports both Class and String for lazy loading)
        config.tools.each do |tool_or_name|
          tool = build_tool(tool_or_name)
          toolkit.add_tool(tool)
        end

        # Run any configuration blocks
        config.blocks.each do |block|
          block.call(toolkit)
        end

        toolkit
      end

      # Build a tool instance from a tool or name
      #
      # @param tool_or_name [Tool::Base, String, Class] The tool or name of the tool
      # @return [Tool::Base] The built tool instance
      # @raise [ArgumentError] if tool_or_name is not valid
      def build_tool(tool_or_name)
        case tool_or_name
        when String
          tool_or_name.constantize.new
        when Class
          tool_or_name.new
        when Tool::Base
          tool_or_name # Already an instance
        else
          raise ArgumentError, "Invalid tool: #{tool_or_name.inspect}"
        end
      end
    end

    # Stores toolkit configuration for lazy instantiation
    #
    # This is a simple data object that holds the configuration
    # until the toolkit is actually needed.
    class Toolkit
      attr_reader :id
      attr_reader :class_name
      attr_reader :tools
      attr_reader :blocks

      def initialize(id, class_name: nil)
        @id = id
        @class_name = class_name
        @tools = []
        @blocks = []
      end
    end
  end
end
