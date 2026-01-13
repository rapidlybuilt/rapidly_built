require "test_helper"

module RapidlyBuilt
  class ApplicationTest < ActiveSupport::TestCase
    # Test plugin class scoped to this test class
    class TestPlugin < Base
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

    test "initializes with empty plugins array" do
      assert_equal [], @app.plugins
    end

    test "initializes with search_middleware" do
      assert_instance_of Middleware, @app.search_middleware
    end

    test "initializes with layout_middleware" do
      assert_instance_of Middleware, @app.layout_middleware
    end

    test "#add_plugin adds plugin to plugins array" do
      plugin = TestPlugin.new
      @app.add_plugin(plugin)

      assert_equal 1, @app.plugins.size
      assert_equal plugin, @app.plugins.first
    end

    test "#add_plugin calls connect on the plugin" do
      plugin = TestPlugin.new
      @app.add_plugin(plugin)

      assert plugin.connected
    end

    test "#add_plugin returns self" do
      plugin = TestPlugin.new
      result = @app.add_plugin(plugin)

      assert_equal @app, result
    end

    test "#add_plugin can add multiple plugins" do
      plugin1 = TestPlugin.new
      plugin2 = TestPlugin.new
      @app.add_plugin(plugin1)
      @app.add_plugin(plugin2)

      assert_equal 2, @app.plugins.size
      assert_equal [ plugin1, plugin2 ], @app.plugins
    end

    test "raises error if adding plugin to mounted application" do
      @app.mark_as_mounted!
      plugin = TestPlugin.new
      assert_raises RuntimeError, "Cannot add plugins to an application that has already been mounted in a Rails engine" do
        @app.add_plugin(plugin)
      end
    end
  end
end
