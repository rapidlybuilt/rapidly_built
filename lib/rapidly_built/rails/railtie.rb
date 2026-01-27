module RapidlyBuilt
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "rapidly_built.configure_reloading" do
        RapidlyBuilt.config.reload_classes = ::Rails.env.development?
      end

      rake_tasks do
        load File.expand_path("../../tasks/rapidly_built_tasks.rake", __dir__)
      end
    end
  end
end
