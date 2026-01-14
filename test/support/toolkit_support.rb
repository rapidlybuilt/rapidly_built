module ToolkitSupport
  def redraw_routes
    # Clear and redraw the engine's routes so the new tool is mounted
    RapidlyBuilt::Rails::Engine.instance_variable_set(:@routes, nil)
    RapidlyBuilt::Rails::Engine.routes.draw { }

    # Reload app routes to pick up the engine's new routes
    Rails.application.reload_routes!
  end
end
