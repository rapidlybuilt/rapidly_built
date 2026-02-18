module RapidlyBuilt
  class Engine < Rails::Engine
    isolate_namespace RapidlyBuilt

    initializer "rapidly_built.icon_paths" do
      app_icons_path = Rails.root.join("vendor/lucide_icons")
      RapidUI.config.icon_paths << app_icons_path if app_icons_path.exist?
    end
  end
end
