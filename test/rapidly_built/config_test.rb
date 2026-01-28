require "test_helper"

module RapidlyBuilt
  class ConfigTest < ActiveSupport::TestCase
    # Test tool class scoped to this test class
    class TestTool < Tool::Base
      def connect(app)
      end
    end

    # Test toolkit class scoped to this test class
    class TestToolkit < Toolkit::Base
    end

    setup do
      @config = Config.new
    end

    test "#toolkits returns the Toolkits instance" do
      assert_instance_of Config::Toolkits, @config.toolkits
    end

    class ToolkitsTest < ActiveSupport::TestCase
      setup do
        @toolkits = Config::Toolkits.new
      end

      test "#new creates a toolkit configuration" do
        @toolkits.new(:admin)
        assert_instance_of RapidlyBuilt::Toolkit::Base, @toolkits.find!(:admin)
      end

      test "#new converts string id to symbol" do
        @toolkits.new("admin")
        assert_instance_of RapidlyBuilt::Toolkit::Base, @toolkits.find!(:admin)
      end

      test "#new raises if toolkit already defined" do
        @toolkits.new(:admin)
        assert_raises(RapidlyBuilt::ToolkitAlreadyDefinedError) do
          @toolkits.new(:admin)
        end
      end

      test "#new accepts class_name option for custom toolkit class" do
        @toolkits.new(:admin, class_name: "RapidlyBuilt::ConfigTest::TestToolkit")
        toolkit = @toolkits.find!(:admin)
        assert_instance_of TestToolkit, toolkit
      end

      test "#new stores block for lazy execution" do
        block_called = false
        @toolkits.new(:admin) do |toolkit|
          block_called = true
          assert_instance_of Toolkit::Base, toolkit
        end

        assert_not block_called, "Block should not be called until find!"
        @toolkits.find!(:admin)
        assert block_called, "Block should be called on find!"
      end

      test "#configure adds block to existing toolkit" do
        @toolkits.new(:admin)

        block_called = false
        @toolkits.configure(:admin) do |toolkit|
          block_called = true
        end

        @toolkits.find!(:admin)
        assert block_called
      end

      test "#configure raises if toolkit not found" do
        assert_raises(RapidlyBuilt::ToolkitNotFoundError) do
          @toolkits.configure(:nonexistent) { }
        end
      end

      test "#find! builds toolkit on first access" do
        @toolkits.new(:admin)
        toolkit = @toolkits.find!(:admin)
        assert_instance_of Toolkit::Base, toolkit
      end

      test "#find! returns cached instance on subsequent calls" do
        @toolkits.new(:admin)
        toolkit1 = @toolkits.find!(:admin)
        toolkit2 = @toolkits.find!(:admin)
        assert_same toolkit1, toolkit2
      end

      test "#find! raises if toolkit not found" do
        assert_raises(RapidlyBuilt::ToolkitNotFoundError) do
          @toolkits.find!(:nonexistent)
        end
      end

      test "#find! block receives built toolkit and can add tools" do
        @toolkits.new(:admin) do |toolkit|
          toolkit.add_tool(TestTool.new)
        end

        toolkit = @toolkits.find!(:admin)
        assert_equal 1, toolkit.tools.size
        assert_instance_of TestTool, toolkit.tools.first
      end

      test "#find! builds tools from Class in config.tools" do
        @toolkits.new(:admin)
        config = @toolkits.send(:instance_variable_get, :@configs)[:admin]
        config.tools << TestTool

        toolkit = @toolkits.find!(:admin)
        assert_equal 1, toolkit.tools.size
        assert_instance_of TestTool, toolkit.tools.first
      end

      test "#find! builds tools from String in config.tools" do
        @toolkits.new(:admin)
        config = @toolkits.send(:instance_variable_get, :@configs)[:admin]
        config.tools << "RapidlyBuilt::ConfigTest::TestTool"

        toolkit = @toolkits.find!(:admin)
        assert_equal 1, toolkit.tools.size
        assert_instance_of TestTool, toolkit.tools.first
      end

      test "#find! uses tool instance directly from config.tools" do
        @toolkits.new(:admin)
        config = @toolkits.send(:instance_variable_get, :@configs)[:admin]
        tool_instance = TestTool.new
        config.tools << tool_instance

        toolkit = @toolkits.find!(:admin)
        assert_equal 1, toolkit.tools.size
        assert_same tool_instance, toolkit.tools.first
      end

      test "#find! raises ArgumentError for invalid tool in config.tools" do
        @toolkits.new(:admin)
        config = @toolkits.send(:instance_variable_get, :@configs)[:admin]
        config.tools << 12345

        assert_raises(ArgumentError) do
          @toolkits.find!(:admin)
        end
      end

      test "#find! runs multiple blocks in order" do
        order = []
        @toolkits.new(:admin) do |toolkit|
          order << 1
        end
        @toolkits.configure(:admin) do |toolkit|
          order << 2
        end

        @toolkits.find!(:admin)
        assert_equal [1, 2], order
      end

      test "#reload! clears cached instances" do
        @toolkits.new(:admin)
        toolkit1 = @toolkits.find!(:admin)

        @toolkits.reload!

        toolkit2 = @toolkits.find!(:admin)
        assert_not_same toolkit1, toolkit2
      end

      test "#reload! does not clear configurations" do
        @toolkits.new(:admin)
        @toolkits.reload!
        assert_not_nil @toolkits.find!(:admin)
      end
    end

    class ToolkitConfigTest < ActiveSupport::TestCase
      test "initializes with id and empty collections" do
        config = Config::Toolkit.new(:admin)
        assert_equal :admin, config.id
        assert_nil config.class_name
        assert_equal [], config.tools
        assert_equal [], config.blocks
      end

      test "initializes with class_name option" do
        config = Config::Toolkit.new(:admin, class_name: "MyToolkit")
        assert_equal "MyToolkit", config.class_name
      end
    end
  end
end
