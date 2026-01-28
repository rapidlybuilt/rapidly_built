require "test_helper"

module RapidlyBuilt
  module Toolkit
    class BaseTest < ActiveSupport::TestCase
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
        @toolkit = Toolkit::Base.new(:default)
      end

      test "initializes with empty tools array" do
        assert_equal [], @toolkit.tools
      end

      test "initializes with search container" do
        assert_instance_of Search::Container, @toolkit.search
        assert_instance_of Search::Static, @toolkit.search.static
        assert_instance_of Middleware, @toolkit.search.dynamic
      end

      test "initializes with context_middleware" do
        assert_instance_of Middleware, @toolkit.context_middleware
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
        tool2 = TestTool.new(id: "tool2")
        @toolkit.add_tool(tool1)
        @toolkit.add_tool(tool2)

        assert_equal 2, @toolkit.tools.size
        assert_equal [ tool1, tool2 ], @toolkit.tools
      end

      test "raises an error when adding a tool with the same class and id" do
        tool1 = TestTool.new
        tool2 = TestTool.new(id: tool1.id)
        @toolkit.add_tool(tool1)
        assert_raises ToolNotUniqueError, "Tool TestTool with id #{tool1.id} not found" do
          @toolkit.add_tool(tool2)
        end
      end

      test "#find_tool! raises ToolNotFoundError if tool is not found" do
        assert_raises ToolNotFoundError, "Tool TestTool with id nil not found" do
          @toolkit.find_tool!(TestTool)
        end
      end

      test "#find_tool! returns tool if found" do
        tool = TestTool.new
        @toolkit.add_tool(tool)

        assert_equal tool, @toolkit.find_tool!(TestTool)
      end

      test "#find_tool returns tool if found" do
        tool = TestTool.new
        @toolkit.add_tool(tool)

        assert_equal tool, @toolkit.find_tool(TestTool)
      end

      test "#find_tool returns nil if tool is not found" do
        assert_nil @toolkit.find_tool(TestTool)
      end
    end
  end
end
