require "delegate"

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
      console_id = params[:console_id] || :application

      # OPTIMIZE: caching
      console_class = Setup.find_console_class(console_id)
      console = console_class.new(id: console_id)

      context = Request::Context.new(
        console:,
        ui:, # from RapidUI::UsesLayout
        controller: self,
      )

      console.request.middleware.call(context)
      @rapidly_built = context
    end

    class << self
      def find_console_class(id)
        "#{id}_console".camelize.constantize
      end
    end
  end
end
