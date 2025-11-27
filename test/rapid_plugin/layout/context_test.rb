require "test_helper"

module RapidPlugin
  module Layout
    class ContextTest < ActiveSupport::TestCase
      setup do
        @layout = Object.new
        @application = Application.new
        @context = Context.new(layout: @layout, application: @application)
      end

      test "initializes with layout and application" do
        assert_equal @layout, @context.layout
        assert_equal @application, @context.application
      end
    end
  end
end

