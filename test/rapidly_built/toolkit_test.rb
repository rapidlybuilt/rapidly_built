require "test_helper"

module RapidlyBuilt
  class ToolkitTest < ActiveSupport::TestCase
    # Test tool class scoped to this test class
    class TestTool < Tool
      attr_reader :connected

      def initialize(**options)
        super(**options)
        @connected = false
      end

      def connect(app)
        @connected = true
      end

      def mount(routes)
      end
    end

    setup do
      @toolkit = Toolkit.new
    end

    test "initializes with empty tools array" do
      assert_equal [], @toolkit.tools
    end

    test "initializes with search_middleware" do
      assert_instance_of Middleware, @toolkit.search_middleware
    end

    test "initializes with layout_middleware" do
      assert_instance_of Middleware, @toolkit.layout_middleware
    end

    test "#add_tool adds tool to tools array" do
      tool = TestTool.new
      @toolkit.add_tool(tool)

      assert_equal 1, @toolkit.tools.size
      assert_equal tool, @toolkit.tools.first
    end

    test "#add_tool calls connect on the tool" do
      tool = TestTool.new
      @toolkit.add_tool(tool)

      assert tool.connected
    end

    test "#add_tool returns self" do
      tool = TestTool.new
      result = @toolkit.add_tool(tool)

      assert_equal @toolkit, result
    end

    test "#add_tool can add multiple tools" do
      tool1 = TestTool.new
      tool2 = TestTool.new
      @toolkit.add_tool(tool1)
      @toolkit.add_tool(tool2)

      assert_equal 2, @toolkit.tools.size
      assert_equal [ tool1, tool2 ], @toolkit.tools
    end

    test "raises error if adding tool to mounted toolkit" do
      @toolkit.mark_as_mounted!
      tool = TestTool.new
      assert_raises RuntimeError, "Cannot add tools to a toolkit that has already been mounted in a Rails engine" do
        @toolkit.add_tool(tool)
      end
    end
  end
end

