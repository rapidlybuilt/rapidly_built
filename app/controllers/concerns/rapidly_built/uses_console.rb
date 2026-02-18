require "delegate"

module RapidlyBuilt
  # Setup for integrating RapidlyBuilt with Rails controllers
  #
  # Provides access to the RapidlyBuilt Console and
  # sets up the context via the console's request middleware.
  #
  # @example
  #   class ApplicationController < ActionController::Base
  #     include RapidlyBuilt::UsesConsole
  #   end
  module UsesConsole
    extend ActiveSupport::Concern

    included do
      extend RapidUI::UsesLayout
      uses_application_layout

      before_action :set_current_console
    end

    private

    attr_reader :current_console

    # Initialize the layout using the toolkit's layout middleware
    def set_current_console
      console_id = params[:console_id] || :application

      # OPTIMIZE: caching
      console_class = UsesConsole.find_console_class(console_id)
      console = console_class.new(id: console_id)

      context = Request::Context.new(
        console:,
        ui:, # from RapidUI::UsesLayout
        controller: self,
      )

      console.request.middleware.call(context)
      @current_console = console
    end

    class << self
      def find_console_class(id)
        "#{id}_console".camelize.constantize
      end
    end
  end
end
