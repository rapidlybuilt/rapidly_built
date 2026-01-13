require "test_helper"

module RapidlyBuilt
  module Layout
    class MiddlewareTest < ActiveSupport::TestCase
      setup do
        @layout = Object.new
        @application = Application.new
      end

      test "#call raises NotImplementedError by default" do
        middleware = Middleware.new
        context = Context.new(layout: @layout, application: @application)

        assert_raises NotImplementedError do
          middleware.call(context)
        end
      end

      test "can be initialized with url_helpers" do
        url_helpers = Module.new
        middleware = Middleware.new(url_helpers: url_helpers)
        assert_equal url_helpers, middleware.url_helpers
      end

      test "url_helpers defaults to nil" do
        middleware = Middleware.new
        assert_nil middleware.url_helpers
      end

      test "#routes returns url_helpers" do
        url_helpers = Module.new
        middleware = Middleware.new(url_helpers: url_helpers)
        assert_equal url_helpers, middleware.routes
      end

      test "#routes returns nil when url_helpers not set" do
        middleware = Middleware.new
        assert_nil middleware.routes
      end

      test "subclass can implement #call" do
        test_middleware = Class.new(Middleware) do
          def call(context)
            # Modify the context in some way
            context
          end
        end

        middleware = test_middleware.new
        context = Context.new(layout: @layout, application: @application)
        result = middleware.call(context)

        assert_equal context, result
      end

      test "subclass can use routes in #call" do
        url_helpers = Module.new do
          def self.root_path
            "/root"
          end
        end

        test_middleware = Class.new(Middleware) do
          def call(context)
            # Can use routes.root_path here
            _path = routes.root_path
            context
          end
        end

        middleware = test_middleware.new(url_helpers: url_helpers)
        context = Context.new(layout: @layout, application: @application)
        result = middleware.call(context)

        assert_equal context, result
      end
    end
  end
end
