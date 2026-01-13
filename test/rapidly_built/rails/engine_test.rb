require "test_helper"

module RapidlyBuilt
  module Rails
    class EngineTest < ActiveSupport::TestCase
      # Test tool class scoped to this test class
      class TestTool < Base
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
        @app = @config.default_application
        @tool1 = TestTool.new
        @tool2 = TestTool.new
        @app.add_tool(@tool1)
        @app.add_tool(@tool2)
      end

      test "#tool_application returns the default application" do
        # Use the singleton config's default application
        default_app = RapidlyBuilt.config.default_application
        engine = Engine.allocate

        assert_equal default_app, engine.tool_application
      end

      test "default engine mounts all tools" do
        engine_instance = Engine.instance
        engine_instance.routes.draw { }

        assert @app.mounted?
        assert_not_nil @tool1.mounted_routes
        assert_not_nil @tool2.mounted_routes
      end

      test "#build_engine_for mounts all tools" do
        app = Application.new
        tool1 = TestTool.new
        tool2 = TestTool.new
        app.add_tool(tool1)
        app.add_tool(tool2)

        # Capture app in closure for routes block
        engine = Engine.build_engine_for(app)

        engine_instance = engine.instance
        # Draw routes to trigger the routes block
        engine_instance.routes.draw { }

        assert app.mounted?
        assert_not_nil tool1.mounted_routes
        assert_not_nil tool2.mounted_routes
      end

      test "dynamically created engine subclass returns correct application" do
        custom_app = @config.build_application(:admin, tools: [])
        engine_class = @config.engine(:admin)
        engine = engine_class.allocate

        assert_equal custom_app, engine.tool_application
      end

      test "dynamically created engine subclass isolates applications" do
        admin_app = @config.build_application(:admin, tools: [])
        root_app = @config.build_application(:root, tools: [])

        admin_engine = @config.engine(:admin).allocate
        root_engine = @config.engine(:root).allocate

        assert_equal admin_app, admin_engine.tool_application
        assert_equal root_app, root_engine.tool_application
        assert_not_equal admin_engine.tool_application, root_engine.tool_application
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
