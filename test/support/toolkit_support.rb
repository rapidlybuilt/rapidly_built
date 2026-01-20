module ToolkitSupport
  def redraw_routes(&block)
    # Just reload app routes - the custom engine's routes are drawn
    # when the engine class is created via build_engine_for
    Rails.application.reload_routes!
    Rails.application.routes.draw(&block) if block_given?
  end
end
