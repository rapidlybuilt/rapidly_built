require "test_helper"

module RapidPlugin
  module Rails
    class ControllerHelperTest < ActionController::TestCase
      # Test controller that includes the helper
      class TestController < ActionController::Base
        include ControllerHelper

        before_action :initialize_rapid_layout

        def index
          render plain: "OK"
        end

        private

        # Override layout method to return a test layout object
        # This simulates getting the layout instance
        def layout
          @test_layout ||= Object.new
        end
      end

      # Test layout middleware
      class TestLayoutMiddleware < Layout::Middleware
        attr_reader :called_with_context

        def initialize(**options)
          super(**options)
          @called_with_context = nil
        end

        def call(context)
          @called_with_context = context
          context
        end
      end

      setup do
        @app = RapidPlugin.config.default_application
        @admin_app = RapidPlugin.config.build_application(:admin, plugins: [])
        @controller = TestController.new
        @routes = ActionDispatch::Routing::RouteSet.new
        @routes.draw do
          get "index", to: "rapid_plugin/rails/controller_helper_test/test#index"
        end
        @controller.instance_variable_set(:@_routes, @routes)
      end

      test "#application returns default application when no param is set" do
        get :index

        assert_equal @app, @controller.send(:application)
      end

      test "#application returns application based on app param" do
        get :index, params: { app_id: "admin" }

        assert_equal @admin_app, @controller.send(:application)
      end

      test "#rapid_layout returns the layout after initialization" do
        get :index

        assert_not_nil @controller.send(:rapid_layout)
      end

      test "nonexistent application raises ApplicationNotFoundError" do
        assert_raises ApplicationNotFoundError do
          get :index, params: { app_id: "nonexistent" }
        end
      end

      test "running layout middleware" do
        @app.layout_middleware.use(TestLayoutMiddleware)

        get :index

        # Get the middleware instance from the stack
        middleware_entry = @app.layout_middleware.entries.first
        middleware = middleware_entry.instance

        assert_not_nil middleware.called_with_context.layout
        assert_equal @app, middleware.called_with_context.application
      end

      test "finalizing the layout" do
        finalized_contexts = []
        modified_layout = Object.new

        @controller.define_singleton_method :finalize_layout do |context|
          finalized_contexts << context
          Layout::Context.new(layout: modified_layout, application: context.application)
        end

        get :index

        assert_equal 1, finalized_contexts.size
        assert_equal modified_layout, @controller.send(:rapid_layout)
      end
    end
  end
end

