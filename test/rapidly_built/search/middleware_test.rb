require "test_helper"

module RapidlyBuilt
  module Search
    class MiddlewareTest < ActiveSupport::TestCase
      class MyMiddleware < Middleware::Entry
        def call
          add_result(title: "My Result", url: "/my_result")
        end
      end

      setup do
        @console = Object.new
        @context = Context.new(query_string: "test", console: @console)
        @stack = Support::Middleware::ContextStack.new
        @stack.use MyMiddleware
        # @middleware = MyMiddleware.new(@context)
      end

      test "adds a search result" do
        @stack.call(@context)
        assert_equal 1, @context.results.size
        assert_equal "My Result", @context.results.first.title
        assert_equal "/my_result", @context.results.first.url
      end
    end
  end
end
