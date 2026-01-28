require "test_helper"

module RapidlyBuilt
  class ConfigTest < ActiveSupport::TestCase
    # Test tool class scoped to this test class
    class TestTool < Tool::Base
      def connect(app)
      end
    end

    setup do
      @config = Config.new
    end

    test "#build_toolkit creates a toolkit with the given name" do
      toolkit = @config.build_toolkit(:admin, tools: [])

      assert_instance_of Toolkit::Base, toolkit
      assert_equal toolkit, @config.find_toolkit!(:admin)
    end

    test "#build_toolkit converts name to symbol" do
      toolkit = @config.build_toolkit("admin", tools: [])

      assert_equal toolkit, @config.find_toolkit!(:admin)
    end

    test "#build_toolkit adds tools to the toolkit by class or instance" do
      toolkit = @config.build_toolkit(:admin, tools: [ TestTool, TestTool.new(id: "tool2") ])

      assert_equal 2, toolkit.tools.size
      assert_instance_of TestTool, toolkit.tools.first
      assert_instance_of TestTool, toolkit.tools.last
    end

    test "#build_toolkit returns the created toolkit" do
      toolkit = @config.build_toolkit(:admin, tools: [])

      assert_instance_of Toolkit::Base, toolkit
    end

    test "#default_toolkit creates a new toolkit if it doesn't exist" do
      toolkit = @config.default_toolkit

      assert_instance_of Toolkit::Base, toolkit
      assert_equal toolkit, @config.default_toolkit
    end

    test "#default_toolkit returns the same toolkit on subsequent calls" do
      toolkit1 = @config.default_toolkit
      toolkit2 = @config.default_toolkit

      assert_equal toolkit1, toolkit2
    end

    test "#find_toolkit! returns the default toolkit when name is nil" do
      default = @config.default_toolkit
      toolkit = @config.find_toolkit!(nil)

      assert_equal default, toolkit
    end

    test "#find_toolkit! returns the default toolkit when name is :default" do
      default = @config.default_toolkit
      toolkit = @config.find_toolkit!(:default)

      assert_equal default, toolkit
    end

    test "#find_toolkit! returns the default toolkit when no name is provided" do
      default = @config.default_toolkit
      toolkit = @config.find_toolkit!(nil)

      assert_equal default, toolkit
    end

    test "#find_toolkit! returns a toolkit by name" do
      admin_toolkit = @config.build_toolkit(:admin, tools: [])

      assert_equal admin_toolkit, @config.find_toolkit!(:admin)
    end

    test "#find_toolkit! converts name to symbol" do
      admin_toolkit = @config.build_toolkit(:admin, tools: [])

      assert_equal admin_toolkit, @config.find_toolkit!("admin")
    end

    test "#find_toolkit! raises ToolkitNotFoundError for non-existent toolkit" do
      assert_raises ToolkitNotFoundError do
        @config.find_toolkit!(:nonexistent)
      end
    end

    test "#toolkits returns a hash of all toolkits" do
      admin_toolkit = @config.build_toolkit(:admin, tools: [])
      root_toolkit = @config.build_toolkit(:root, tools: [])

      toolkits = @config.toolkits

      assert_instance_of Hash, toolkits
      assert_equal admin_toolkit, toolkits[:admin]
      assert_equal root_toolkit, toolkits[:root]
    end

    test "#toolkits returns a duplicate hash" do
      @config.build_toolkit(:admin, tools: [])
      toolkits1 = @config.toolkits
      toolkits2 = @config.toolkits

      assert_not_same toolkits1, toolkits2
    end
  end
end
