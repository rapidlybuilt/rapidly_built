require "test_helper"

module RapidPlugin
  module Search
    class MiddlewareTest < ActiveSupport::TestCase
      setup do
        @application = Object.new
      end

      test "#call raises NotImplementedError by default" do
        middleware = Middleware.new
        context = Context.new(query_string: "test", application: @application)

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
            context.add_result(title: "Test", url: "/test")
            context
          end
        end

        middleware = test_middleware.new
        context = Context.new(query_string: "test", application: @application)
        result = middleware.call(context)

        assert_equal 1, result.results.size
        assert_equal "Test", result.results.first.title
      end

      test "subclass can use routes in #call" do
        url_helpers = Module.new do
          def self.root_path
            "/root"
          end
        end

        test_middleware = Class.new(Middleware) do
          def call(context)
            context.add_result(title: "Test", url: routes.root_path)
            context
          end
        end

        middleware = test_middleware.new(url_helpers: url_helpers)
        context = Context.new(query_string: "test", application: @application)
        result = middleware.call(context)

        assert_equal "/root", result.results.first.url
      end
    end
  end
end
