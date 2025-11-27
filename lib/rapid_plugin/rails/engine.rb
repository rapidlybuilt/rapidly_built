module RapidPlugin
  module Rails
    # Mountable Rails engine that mounts all of a specific RapidPlugin::Application's plugins
    #
    # @example
    #   # config/routes.rb
    #   Rails.application.routes.draw do
    #     mount RapidPlugin::Engine, at: "/admin"
    #   end
    #
    # @example With a specific application
    #   # config/routes.rb
    #   Rails.application.routes.draw do
    #     mount RapidPlugin::Engine, at: "/admin", defaults: { rapid_plugin_app: "admin" }
    #   end
    class Engine < ::Rails::Engine
      isolate_namespace RapidPlugin

      routes do
        Engine.draw_application_routes(RapidPlugin.config.default_application, self)
      end

      # Get the application for this engine instance
      # Subclasses override this to return a specific application
      #
      # @return [Application] The application instance
      def plugin_application
        RapidPlugin.config.default_application
      end

      class << self
        def build_engine_for(app)
          Class.new(Rails::Engine) do
            define_method :plugin_application do
              app
            end

            routes do
              Engine.draw_application_routes(app, self)
            end
          end
        end

        # Mount all plugins from an application onto the routes mapper
        #
        # @param app [Application] The application containing plugins to mount
        # @param routes [ActionDispatch::Routing::Mapper] The routes mapper
        def draw_application_routes(app, routes)
          app.mark_as_mounted!
          app.plugins.each do |plugin|
            plugin.mount(routes)
          end
        end
      end
    end
  end
end
