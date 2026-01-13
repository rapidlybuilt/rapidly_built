module RapidlyBuilt
  module Rails
    # Controller helper for integrating RapidlyBuilt with Rails controllers
    #
    # Provides access to the mounted RapidlyBuilt::Toolkit instance and
    # sets up layout initialization via the toolkit's layout middleware.
    #
    # @example
    #   class ApplicationController < ActionController::Base
    #     include RapidlyBuilt::Rails::ControllerHelper
    #   end
    module ControllerHelper
      extend ActiveSupport::Concern
      include RapidUI::UsesLayout

      included do
        before_action :setup_rapidly_built
      end

      private

      # Get the RapidlyBuilt::Toolkit instance for the current request
      #
      # @return [Toolkit, nil] The toolkit instance, or nil if not found
      def toolkit
        @toolkit ||= find_toolkit || raise(ToolkitNotFoundError, "Toolkit not found")
      end

      # Get the current layout instance
      #
      # @return [Object, nil] The layout instance
      def rapid_layout
        # #layout conflicts with ActionController so using rapid_layout
        @rapid_layout
      end

      # Find the RapidlyBuilt::Toolkit instance using the app parameter
      #
      # @return [Toolkit, nil] The toolkit instance, or nil if not found
      def find_toolkit(name = params[:app_id])
        RapidlyBuilt.config.toolkit(name)
      end

      # Initialize the layout using the toolkit's layout middleware
      def setup_rapidly_built
        return unless toolkit

        context = Layout::Context.new(layout:, toolkit:)

        # Run the layout middleware stack
        context = toolkit.layout_middleware.call(context)
        context = finalize_layout(context)

        @rapid_layout = context.layout
      end

      # Allow controllers the last chance to modify the layout
      #
      # @param context [Layout::Context] The layout context
      # @return [Layout::Context] The modified layout context
      def finalize_layout(context)
        context
      end
    end
  end
end
