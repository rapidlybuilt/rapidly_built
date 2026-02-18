require "test_helper"

module RapidlyBuilt
  class SetupTest < ActionController::TestCase
    include ConsoleSupport

    # Test controller that includes the helper
    class TestController < ActionController::Base
      include RapidlyBuilt::Setup

      def index
        render plain: "OK"
      end

      private

      def layout
        @test_layout ||= Object.new
      end
    end

    # Test request middleware. Works with Request middleware ContextStack:
    # context is set via context=, then call is invoked with no args.
    class TestRequestMiddleware
      attr_accessor :context
      attr_reader :called_with_context

      def initialize(**options)
        @called_with_context = nil
      end

      def call
        @called_with_context = context
        context
      end
    end

    setup do
      @controller = TestController.new
      @routes = ActionDispatch::Routing::RouteSet.new
      @routes.draw do
        get "index", to: "rapidly_built/setup_test/test#index"
      end
      @controller.instance_variable_set(:@_routes, @routes)
    end

    teardown do
      unstub_test_console
    end

    test "nonexistent console_id raises NameError" do
      unstub_console

      assert_raises NameError do
        get :index, params: { console_id: "nonexistent" }
      end
    end

    test "running request middleware" do
      stub_test_console do |console|
        console.request.middleware.use(TestRequestMiddleware)
      end

      get :index

      context = @controller.send(:rapidly_built)
      middleware_entry = context.console.request.middleware.entries.first
      middleware = middleware_entry.instance

      assert_not_nil middleware.called_with_context.ui.layout
      assert_equal context.console, middleware.called_with_context.console
    end

    test "sets rapidly_built with console" do
      stub_test_console do |console|
        @console = console
        console.request.middleware.use(TestRequestMiddleware)
      end

      get :index

      context = @controller.send(:rapidly_built)
      assert_equal @console, context.console
    end
  end
end
