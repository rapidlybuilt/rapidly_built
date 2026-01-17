require "test_helper"

module RapidlyBuilt
  class ToolTest < ActiveSupport::TestCase
    # Test tool class scoped to this test class
    class MyTool < Tool
      def connect(app)
      end

      def mount(routes)
      end
    end

    test "#id is nil by default" do
      tool = MyTool.new

      assert_nil tool.id
    end

    test "#id returns the custom ID when provided" do
      tool = MyTool.new(id: "custom_id")
      assert_equal "custom_id", tool.id
    end

    test "#path is the parent of the tool class by default" do
      tool = MyTool.new
      assert_equal "tool-test", tool.path
    end

    test "#path is settable" do
      tool = MyTool.new(path: "test")
      assert_equal "test", tool.path
    end

    test "base tool exposes connect and mount methods with safe defaults" do
      tool = RapidlyBuilt::Tool.new

      assert_nothing_raised { tool.connect(nil) }
      assert_nothing_raised { tool.mount(nil) }
    end
  end
end
