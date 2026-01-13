require "test_helper"

module RapidlyBuilt
  module Rails
    class EngineTest < ActiveSupport::TestCase
      # Test tool class scoped to this test class
      class TestTool < Tool
        attr_reader :mounted_routes

        def initialize(**options)
          super(**options)
        end

        def connect(app)
        end

        def mount(routes)
          @mounted_routes = true
        end
      end

      setup do
        @config = RapidlyBuilt.config
        @toolkit = @config.default_toolkit
        @tool1 = TestTool.new
        @tool2 = TestTool.new
        @toolkit.add_tool(@tool1)
        @toolkit.add_tool(@tool2)
      end

      test "#toolkit returns the default toolkit" do
        # Use the singleton config's default toolkit
        default_toolkit = RapidlyBuilt.config.default_toolkit
        engine = Engine.allocate

        assert_equal default_toolkit, engine.toolkit
      end

      test "default engine mounts all tools" do
        engine_instance = Engine.instance
        engine_instance.routes.draw { }

        assert @toolkit.mounted?
        assert_not_nil @tool1.mounted_routes
        assert_not_nil @tool2.mounted_routes
      end

      test "#build_engine_for mounts all tools" do
        toolkit = Toolkit.new
        tool1 = TestTool.new
        tool2 = TestTool.new
        toolkit.add_tool(tool1)
        toolkit.add_tool(tool2)

        # Capture toolkit in closure for routes block
        engine = Engine.build_engine_for(toolkit)

        engine_instance = engine.instance
        # Draw routes to trigger the routes block
        engine_instance.routes.draw { }

        assert toolkit.mounted?
        assert_not_nil tool1.mounted_routes
        assert_not_nil tool2.mounted_routes
      end

      test "dynamically created engine subclass returns correct toolkit" do
        custom_toolkit = @config.build_toolkit(:admin, tools: [])
        engine_class = @config.engine(:admin)
        engine = engine_class.allocate

        assert_equal custom_toolkit, engine.toolkit
      end

      test "dynamically created engine subclass isolates toolkits" do
        admin_toolkit = @config.build_toolkit(:admin, tools: [])
        root_toolkit = @config.build_toolkit(:root, tools: [])

        admin_engine = @config.engine(:admin).allocate
        root_engine = @config.engine(:root).allocate

        assert_equal admin_toolkit, admin_engine.toolkit
        assert_equal root_toolkit, root_engine.toolkit
        assert_not_equal admin_engine.toolkit, root_engine.toolkit
      end

      test "engine has isolated namespace" do
        # Test that isolate_namespace was called by checking the engine is a Rails::Engine
        assert Engine < ::Rails::Engine
        # Verify the engine is in the RapidlyBuilt::Rails module
        assert_equal RapidlyBuilt::Rails, Engine.module_parent
      end
    end
  end
end
