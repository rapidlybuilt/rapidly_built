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
class MyGem::Tool < RapidlyBuilt::Tool::Base
  def connect(toolkit)
    # Register static search items (searched client-side, instant results)
    toolkit.search.static.add(title: "Dashboard", url: "/dashboard", description: "View your dashboard")

    # Register dynamic search middleware (runs server-side)
    toolkit.search.dynamic.use MyGem::Tool::Search

    toolkit.request.middleware.use MyGem::Tool::LayoutBuilder
  end
end
```

### Rails Integration

* Help your controllers live within the rapid structure

```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :admin, defaults: { app_id: "admin" } do
    mount YourAdminTool::Engine => "your_tool"
  end
```

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # uses params[:app_id] to setup the current toolkit
  include RapidlyBuilt::Setup
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
