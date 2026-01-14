module RapidlyBuilt
  module Rails
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load File.expand_path("../../tasks/rapidly_built_tasks.rake", __dir__)
      end
    end
  end
end
