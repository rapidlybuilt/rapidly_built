require "test_helper"

module RapidlyBuilt
  class ApplicationTest < ActiveSupport::TestCase
    # Test tool class scoped to this test class
    class TestTool < Base
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
      @app = Application.new
    end

    test "initializes with empty tools array" do
      assert_equal [], @app.tools
    end

    test "initializes with search_middleware" do
      assert_instance_of Middleware, @app.search_middleware
    end

    test "initializes with layout_middleware" do
      assert_instance_of Middleware, @app.layout_middleware
    end

    test "#add_tool adds tool to tools array" do
      tool = TestTool.new
      @app.add_tool(tool)

      assert_equal 1, @app.tools.size
      assert_equal tool, @app.tools.first
    end

    test "#add_tool calls connect on the tool" do
      tool = TestTool.new
      @app.add_tool(tool)

      assert tool.connected
    end

    test "#add_tool returns self" do
      tool = TestTool.new
      result = @app.add_tool(tool)

      assert_equal @app, result
    end

    test "#add_tool can add multiple tools" do
      tool1 = TestTool.new
      tool2 = TestTool.new
      @app.add_tool(tool1)
      @app.add_tool(tool2)

      assert_equal 2, @app.tools.size
      assert_equal [ tool1, tool2 ], @app.tools
    end

    test "raises error if adding tool to mounted application" do
      @app.mark_as_mounted!
      tool = TestTool.new
      assert_raises RuntimeError, "Cannot add tools to an application that has already been mounted in a Rails engine" do
        @app.add_tool(tool)
      end
    end
  end
end
