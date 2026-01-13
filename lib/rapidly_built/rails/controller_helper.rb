module RapidlyBuilt
  module Rails
    # Controller helper for integrating RapidlyBuilt with Rails controllers
    #
    # Provides access to the mounted RapidlyBuilt::Application instance and
    # sets up layout initialization via the application's layout middleware.
    #
    # @example
    #   class ApplicationController < ActionController::Base
    #     include RapidlyBuilt::Rails::ControllerHelper
    #   end
    module ControllerHelper
      extend ActiveSupport::Concern

      included do
        before_action :initialize_rapid_layout
      end

      private

      # Get the RapidlyBuilt::Application instance for the current request
      #
      # @return [Application, nil] The application instance, or nil if not found
      def application
        @application ||= find_application || raise(ApplicationNotFoundError, "Application not found")
      end

      # Get the current layout instance
      #
      # @return [Object, nil] The layout instance
      def rapid_layout
        # #layout conflicts with ActionController so using rapid_layout
        @rapid_layout
      end

      # Find the RapidlyBuilt::Application instance using the app parameter
      #
      # @return [Application, nil] The application instance, or nil if not found
      def find_application(name = params[:app_id])
        RapidlyBuilt.config.application(name)
      end

      # Initialize the layout using the application's layout middleware
      def initialize_rapid_layout
        return unless application

        context = Layout::Context.new(layout:, application:)

        # Run the layout middleware stack
        context = application.layout_middleware.call(context)
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
