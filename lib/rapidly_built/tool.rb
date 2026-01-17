module RapidlyBuilt
  # This is the base class for all tools within the RapidlyBuilt system.
  # To create a tool, subclass RapidlyBuilt::Tool and implement the required interface.
  #
  # Example:
  #   class MyGem::Tool < RapidlyBuilt::Tool
  #     def connect(app)
  #       app.search_middleware.use MyGem::Tool::Search
  #       app.context_middleware.use MyGem::Tool::LayoutBuilder
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
    attr_reader :path

    # @option id [String] the ID of the tool. Defaults to nil.
    # @option path [String] the path of the tool. Defaults to the module name of the tool class.
    def initialize(id: nil, path: default_path)
      @id = id
      @path = path
    end

    # Called when the tool is connected to an application.
    # Subclasses should implement this method to register middleware and services.
    #
    # @param app [RapidlyBuilt::Toolkit] The toolkit instance
    def connect(app)
    end

    # Called when the tool's routes should be mounted.
    # Subclasses should implement this method to mount their Rails engine or routes.
    #
    # @param routes [ActionDispatch::Routing::Mapper] The routes mapper
    def mount(routes)
    end

    private

    # @return [String] the default ID of the tool
    def default_path
      class_name = self.class.name
      module_name = ActiveSupport::Inflector.deconstantize(class_name)
      parent_name = module_name.split("::").last

      path = ActiveSupport::Inflector.underscore(parent_name)
      ActiveSupport::Inflector.dasherize(path)
    end
  end
end
