require "test_helper"

module RapidlyBuilt
  class BaseTest < ActiveSupport::TestCase
    # Test tool class scoped to this test class
    class TestTool < Tool
      def connect(app)
      end

      def mount(routes)
      end
    end

    test "#id returns the default ID when not provided" do
      tool = TestTool.new
      assert_equal "rapidly_built/base_test", tool.id
    end

    test "#id returns the custom ID when provided" do
      tool = TestTool.new(id: "custom_id")
      assert_equal "custom_id", tool.id
    end

    test "#root_path returns the root path of the tool" do
      tool = TestTool.new(id: "test")
      assert_equal "/test", tool.send(:root_path)
    end

    test "base tool exposes connect and mount methods with safe defaults" do
      tool = RapidlyBuilt::Tool.new

      assert_nothing_raised { tool.connect(nil) }
      assert_nothing_raised { tool.mount(nil) }
    end
  end
end
