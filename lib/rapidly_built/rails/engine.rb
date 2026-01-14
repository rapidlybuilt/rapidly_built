module RapidlyBuilt
  module Rails
    # Mountable Rails engine that mounts all of a specific RapidlyBuilt::Toolkit's tools
    #
    # @example
    #   # config/routes.rb
    #   Rails.application.routes.draw do
    #     mount RapidlyBuilt::Engine, at: "/admin"
    #   end
    #
    # @example With a specific toolkit
    #   # config/routes.rb
    #   Rails.application.routes.draw do
    #     mount RapidlyBuilt::Engine, at: "/admin", defaults: { rapidly_built_app: "admin" }
    #   end
    class Engine < ::Rails::Engine
      isolate_namespace RapidlyBuilt

      # Get the toolkit for this engine instance
      # Subclasses override this to return a specific toolkit
      #
      # @return [Toolkit] The toolkit instance
      def toolkit
        raise NotImplementedError, "Subclasses must implement #toolkit"
      end

      class << self
        def build_engine_for(toolkit)
          engine_class = Class.new(Rails::Engine) do
            define_method :toolkit do
              toolkit
            end
          end

          # Draw routes on the new engine class after it's created
          # (routes do blocks inside Class.new don't register properly)
          engine_class.routes.draw do
            Engine.draw_toolkit_routes(toolkit, self)
          end

          # TODO: name the class so bin/rails routes doesn't show #<Class:0x0000000000000000>
          engine_class
        end

        # Mount all tools from a toolkit onto the routes mapper
        #
        # @param toolkit [Toolkit] The toolkit containing tools to mount
        # @param routes [ActionDispatch::Routing::Mapper] The routes mapper
        def draw_toolkit_routes(toolkit, routes)
          toolkit.mark_as_mounted!
          toolkit.tools.each do |tool|
            tool.mount(routes)
          end
        end
      end
    end
  end
end
