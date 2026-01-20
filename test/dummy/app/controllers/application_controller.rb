class ApplicationController < ActionController::Base
  include RapidlyBuilt::Rails::ControllerHelper

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
