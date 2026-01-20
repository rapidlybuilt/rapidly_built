# RapidlyBuilt

RapidlyBuilt is a Ruby gem that enables you to develop modular tools within a unified user interface. Many individual tools come together into a single, cohesive web portal.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rapidly_built"
```

## Usage

* Modify the application layout
* Add to search results
* TODO: add dashboard widgets
* TODO: append notifications

### Register your tool

```ruby
# lib/my_gem.rb
RapidlyBuilt.register_tool! MyGem::Tool
```

### Define your tool

```ruby
# lib/my_gem/tool.rb
class MyGem::Tool < RapidlyBuilt::Tool
  def connect(toolkit)
    toolkit.search_middleware.use MyGem::Tool::Search
    toolkit.context_middleware.use MyGem::Tool::LayoutBuilder
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
  mount RapidlyBuilt::Rails::Engine, at: "/admin"
```

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include RapidlyBuilt::Rails::ControllerHelper
end
```

## Multiple Toolkits

The default toolkit uses registered tools. In order to use only a subset of the registered tools or split the tools into separate mountable engines for different sets of users, you can explicitly define the toolkits.

```ruby
# config/initializers/rapidlybuilt.rb
RapidlyBuilt.config do |config|
  config.build_toolkit :admin, tools: [MyAdmin::Tool, AnotherAdmin::Tool]
  config.build_toolkit :root, tools: [MyRoot::Tool, AnotherRoot::Tool]
end
```

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # explicitly mount it The Rails Way
  mount RapidlyBuilt::Rails::Engine, at: "/admin", as: "admin", defaults: { app_id: "admin" }
  mount RapidlyBuilt::Rails::Engine, at: "/root", as: "root", defaults: { app_id: "root" }

  # or use the helper for convenience
  mount_rapidly_built_toolkit :admin
  mount_rapidly_built_toolkit :root
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
