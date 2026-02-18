require "test_helper"

module RapidlyBuilt
  module Request
    class MiddlewareTest < ActiveSupport::TestCase
      class MyMiddleware < Middleware::Entry
        def call
          ui.layout.build_head do |head|
            head.site_name = "My Site"
          end
        end
      end

      setup do
        @console = Object.new
        @controller = Object.new
        @ui = RapidUI::UsesLayout::UI.new(RapidUI::Factory.new, RapidUI::ApplicationLayout)
        @context = Context.new(console: @console, ui: @ui, controller: @controller)

        @stack = Support::Middleware::ContextStack.new
        @stack.use MyMiddleware
      end

      test "calls the middleware" do
        @stack.call(@context)
        assert_equal "My Site", @ui.layout.head.site_name
      end
    end
  end
end
