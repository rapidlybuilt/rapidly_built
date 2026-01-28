require "test_helper"

module RapidlyBuilt
  class SetupTest < ActionController::TestCase
    # Test controller that includes the helper
    class TestController < ActionController::Base
      include RapidlyBuilt::Setup

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
    class TestRequestMiddleware
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
      RapidlyBuilt.config.toolkits.new(:default)
      RapidlyBuilt.config.toolkits.new(:admin)
      @toolkit = RapidlyBuilt.config.toolkits.find!(:default)
      @admin_toolkit = RapidlyBuilt.config.toolkits.find!(:admin)
      @controller = TestController.new
      @routes = ActionDispatch::Routing::RouteSet.new
      @routes.draw do
        get "index", to: "rapidly_built/setup_test/test#index"
      end
      @controller.instance_variable_set(:@_routes, @routes)
    end

    test "nonexistent toolkit raises ToolkitNotFoundError" do
      assert_raises ToolkitNotFoundError do
        get :index, params: { app_id: "nonexistent" }
      end
    end

    test "running request middleware" do
      @toolkit.request.middleware.use(TestRequestMiddleware)

      get :index

      # Get the middleware instance from the stack
      middleware_entry = @toolkit.request.middleware.entries.first
      middleware = middleware_entry.instance

      assert_not_nil middleware.called_with_context.ui.layout
      assert_equal @toolkit, middleware.called_with_context.toolkit
    end

    test "finalizing the layout" do
      finalized_contexts = []

      @controller.define_singleton_method :finalize_rapidly_built do |context|
        finalized_contexts << context
      end

      get :index

      assert_equal 1, finalized_contexts.size
      assert_equal @toolkit, @controller.send(:rapidly_built).toolkit
    end
  end
end
