require "test_helper"

module RapidlyBuilt
  class ConfigTest < ActiveSupport::TestCase
    # Test tool class scoped to this test class
    class TestTool < Base
      def connect(app)
      end

      def mount(routes)
      end
    end

    setup do
      @config = Config.new
    end

    test "#build_application creates an application with the given name" do
      app = @config.build_application(:admin, tools: [])

      assert_instance_of Application, app
      assert_equal app, @config.application(:admin)
    end

    test "#build_application converts name to symbol" do
      app = @config.build_application("admin", tools: [])

      assert_equal app, @config.application(:admin)
    end

    test "#build_application adds tools to the application" do
      app = @config.build_application(:admin, tools: [ TestTool, TestTool ])

      assert_equal 2, app.tools.size
      assert_instance_of TestTool, app.tools.first
      assert_instance_of TestTool, app.tools.last
    end

    test "#build_application creates an engine for the application" do
      app = @config.build_application(:admin, tools: [])
      engine = @config.engine(:admin)

      assert_instance_of Class, engine
      assert engine < Rails::Engine
      # Test that tool_application method exists and returns the correct app
      # by using instance_eval to call it on a new instance
      engine_instance = engine.allocate
      assert_equal app, engine_instance.tool_application
    end

    test "#build_application returns the created application" do
      app = @config.build_application(:admin, tools: [])

      assert_instance_of Application, app
    end

    test "#default_application creates a new application if it doesn't exist" do
      app = @config.default_application

      assert_instance_of Application, app
      assert_equal app, @config.default_application
    end

    test "#default_application returns the same application on subsequent calls" do
      app1 = @config.default_application
      app2 = @config.default_application

      assert_equal app1, app2
    end

    test "#application returns the default application when name is nil" do
      default = @config.default_application
      app = @config.application(nil)

      assert_equal default, app
    end

    test "#application returns the default application when name is :default" do
      default = @config.default_application
      app = @config.application(:default)

      assert_equal default, app
    end

    test "#application returns the default application when no name is provided" do
      default = @config.default_application
      app = @config.application

      assert_equal default, app
    end

    test "#application returns an application by name" do
      admin_app = @config.build_application(:admin, tools: [])

      assert_equal admin_app, @config.application(:admin)
    end

    test "#application converts name to symbol" do
      admin_app = @config.build_application(:admin, tools: [])

      assert_equal admin_app, @config.application("admin")
    end

    test "#application raises ApplicationNotFoundError for non-existent application" do
      assert_raises ApplicationNotFoundError do
        @config.application(:nonexistent)
      end
    end

    test "#applications returns a hash of all applications" do
      admin_app = @config.build_application(:admin, tools: [])
      root_app = @config.build_application(:root, tools: [])

      apps = @config.applications

      assert_instance_of Hash, apps
      assert_equal admin_app, apps[:admin]
      assert_equal root_app, apps[:root]
    end

    test "#applications returns a duplicate hash" do
      @config.build_application(:admin, tools: [])
      apps1 = @config.applications
      apps2 = @config.applications

      assert_not_same apps1, apps2
    end

    test "#engine returns Rails::Engine when name is nil" do
      engine = @config.engine(nil)

      assert_equal Rails::Engine, engine
    end

    test "#engine returns Rails::Engine when name is :default" do
      engine = @config.engine(:default)

      assert_equal Rails::Engine, engine
    end

    test "#engine returns Rails::Engine when no name is provided" do
      engine = @config.engine

      assert_equal Rails::Engine, engine
    end

    test "#engine returns the engine for a specific application" do
      app = @config.build_application(:admin, tools: [])
      engine = @config.engine(:admin)

      assert_instance_of Class, engine
      assert engine < Rails::Engine
      engine_instance = engine.allocate
      assert_equal app, engine_instance.tool_application
    end

    test "#engine converts name to symbol" do
      app = @config.build_application(:admin, tools: [])
      engine = @config.engine("admin")

      assert_instance_of Class, engine
      assert engine < Rails::Engine
      engine_instance = engine.allocate
      assert_equal app, engine_instance.tool_application
    end

    test "#engine raises ApplicationNotFoundError for non-existent application" do
      assert_raises ApplicationNotFoundError, "Application :nonexistent for engine not found" do
        @config.engine(:nonexistent)
      end
    end
  end
end
