module RapidlyBuilt
  # Setup for integrating RapidlyBuilt with Rails controllers
  #
  # Provides access to the mounted RapidlyBuilt::Toolkit instance and
  # sets up the context via the toolkit's setup middleware.
  #
  # @example
  #   class ApplicationController < ActionController::Base
  #     include RapidlyBuilt::Setup
  #   end
  module Setup
    extend ActiveSupport::Concern

    included do
      extend RapidUI::UsesLayout
      uses_application_layout

      before_action :setup_rapidly_built
    end

    private

    attr_reader :rapidly_built

    # Initialize the layout using the toolkit's layout middleware
    def setup_rapidly_built
      app_id = params[:app_id]

      context = Toolkit::Context.new(
        toolkit: RapidlyBuilt.config.find_toolkit!(app_id),
        ui:, # from RapidUI::UsesLayout
        controller: self,
      )

      # API for modifying the
      context.toolkit.context_middleware.call(context)
      finalize_rapidly_built(context)

      @rapidly_built = context
    end

    # Allow controllers the last chance to modify the context
    #
    # @param context [Context] The context
    def finalize_rapidly_built(context)
    end
  end
end
