# RapidPlugin

RapidPlugin is a Ruby gem that enables you to develop modular plugins within a unified user interface. Many individual plugins come together into a single, cohesive web portal.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rapid_plugin"
```

## Usage

* Modify the application layout
* Add to search results
* TODO: add dashboard widgets
* TODO: append notifications

### Register your plugin

```ruby
# lib/my_gem.rb
RapidPlugin.register! MyGem::Plugin
```

### Define your plugin

```ruby
# lib/my_gem/plugin.rb
class MyGem::Plugin < RapidPlugin::Base
  def connect(app)
    app.search_middleware.use MyGem::Plugin::Search
    app.layout_middleware.use MyGem::Plugin::LayoutBuilder
  end

  def mount(routes)
    routes.mount MyGem::Engine => root_path
  end
end
```

### Rails Integration

* Help your controllers live within the rapid structure

```ruby
# config/routes.rb
Rails.application.routes.draw do
  mount RapidPlugin::Engine, at: "/admin"
```

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include RapidPlugin::Rails::ControllerHelper
end
```

## Multiple Applications

The default application uses registered plugins. In order to use only a subset of the registered plugins or split the plugins into separate mountable engines for different sets of users, you can explicitly define the applications.

```ruby
# config/initializers/rapidlybuilt.rb
RapidPlugin.config do |config|
  config.build_application :admin, plugins: [MyAdmin::Plugin, AnotherAdmin::Plugin]
  config.build_application :root, plugins: [MyRoot::Plugin, AnotherRoot::Plugin]
end
```

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # explicitly mount it The Rails Way
  mount RapidPlugin::Engine, at: "/admin", as: "admin", defaults: { rapid_plugin_app: "admin" }
  mount RapidPlugin::Engine, at: "/root", as: "root", defaults: { rapid_plugin_app: "root" }

  # or use the helper for convenience
  mount_rails_plugin_app :root
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

