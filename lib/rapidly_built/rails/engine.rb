module RapidlyBuilt
  module Rails
    # Mountable Rails engine that mounts all of a specific RapidlyBuilt::Application's tools
    #
    # @example
    #   # config/routes.rb
    #   Rails.application.routes.draw do
    #     mount RapidlyBuilt::Engine, at: "/admin"
    #   end
    #
    # @example With a specific application
    #   # config/routes.rb
    #   Rails.application.routes.draw do
    #     mount RapidlyBuilt::Engine, at: "/admin", defaults: { rapidly_built_app: "admin" }
    #   end
    class Engine < ::Rails::Engine
      isolate_namespace RapidlyBuilt

      routes do
        Engine.draw_application_routes(RapidlyBuilt.config.default_application, self)
      end

      # Get the application for this engine instance
      # Subclasses override this to return a specific application
      #
      # @return [Application] The application instance
      def tool_application
        RapidlyBuilt.config.default_application
      end

      class << self
        def build_engine_for(app)
          Class.new(Rails::Engine) do
            define_method :tool_application do
              app
            end

            routes do
              Engine.draw_application_routes(app, self)
            end
          end
        end

        # Mount all tools from an application onto the routes mapper
        #
        # @param app [Application] The application containing tools to mount
        # @param routes [ActionDispatch::Routing::Mapper] The routes mapper
        def draw_application_routes(app, routes)
          app.mark_as_mounted!
          app.tools.each do |tool|
            tool.mount(routes)
          end
        end
      end
    end
  end
end
