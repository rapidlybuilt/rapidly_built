require "test_helper"

module RapidlyBuilt
  module Layout
    class ContextTest < ActiveSupport::TestCase
      setup do
        @layout = Object.new
        @toolkit = Toolkit.new
        @context = Context.new(layout: @layout, toolkit: @toolkit)
      end

      test "initializes with layout and toolkit" do
        assert_equal @layout, @context.layout
        assert_equal @toolkit, @context.toolkit
      end
    end
  end
end
