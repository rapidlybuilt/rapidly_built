require "test_helper"

module RapidlyBuilt
  class BaseTest < ActiveSupport::TestCase
    # Test plugin class scoped to this test class
    class TestPlugin < Base
      def connect(app)
      end

      def mount(routes)
      end
    end

    test "#id returns the default ID when not provided" do
      plugin = TestPlugin.new
      assert_equal "rapidly_built/base_test", plugin.id
    end

    test "#id returns the custom ID when provided" do
      plugin = TestPlugin.new(id: "custom_id")
      assert_equal "custom_id", plugin.id
    end

    test "#root_path returns the root path of the plugin" do
      plugin = TestPlugin.new(id: "test")
      assert_equal "/test", plugin.send(:root_path)
    end

    test "required methods raise an error when not implemented" do
      plugin = RapidlyBuilt::Base.new

      assert_raises NotImplementedError do
        plugin.connect(nil)
      end

      assert_raises NotImplementedError do
        plugin.mount(nil)
      end
    end
  end
end
