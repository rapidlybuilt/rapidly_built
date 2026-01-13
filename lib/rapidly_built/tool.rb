module RapidlyBuilt
  # This is the base class for all tools within the RapidlyBuilt system.
  # To create a tool, subclass RapidlyBuilt::Tool and implement the required interface.
  #
  # Example:
  #   class MyGem::Tool < RapidlyBuilt::Tool
  #     def connect(app)
  #       app.search_middleware.use MyGem::Tool::Search
  #       app.layout_middleware.use MyGem::Tool::LayoutBuilder
  #     end
  #
  #     def mount(routes)
  #       routes.mount MyGem::Engine => root_path
  #     end
  #   end
  #
  # Tools inheriting from this class can register their own search, layout, and UI extensions.
  # They integrate seamlessly into the unified RapidlyBuilt web portal.
  # See the README for more usage examples and integration patterns.
  class Tool
    attr_reader :id

    # @option id [String] the ID of the tool. Defaults to the module name of the tool class.
    def initialize(id: default_id)
      @id = id
    end

    # Called when the tool is connected to an application.
    # Subclasses should implement this method to register middleware and services.
    #
    # @param app [RapidlyBuilt::Toolkit] The toolkit instance
    def connect(app)
      raise NotImplementedError, "#{self.class} must implement #connect"
    end

    # Called when the tool's routes should be mounted.
    # Subclasses should implement this method to mount their Rails engine or routes.
    #
    # @param routes [ActionDispatch::Routing::Mapper] The routes mapper
    def mount(routes)
      raise NotImplementedError, "#{self.class} must implement #mount"
    end

    private

    # @return [String] the root path of the tool
    def root_path
      "/#{id}"
    end

    # @return [String] the default ID of the tool
    def default_id
      class_name = self.class.name
      module_name = ActiveSupport::Inflector.deconstantize(class_name)
      ActiveSupport::Inflector.underscore(module_name)
    end
  end
end
