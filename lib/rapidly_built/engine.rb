module RapidlyBuilt
  class Engine < Rails::Engine
    isolate_namespace RapidlyBuilt

    config.to_prepare do
      RapidlyBuilt.config.toolkits.reload!
    end

    rake_tasks do
      load File.expand_path("../tasks/rapidly_built_tasks.rake", __dir__)
    end
  end
end
