require "test_helper"

module MountToolTest
  # Define an engine + controller + tool for testing
  class TestToolEngine < ::Rails::Engine
    isolate_namespace MountToolTest

    # Draw routes immediately (routes do block only appends, doesn't draw)
    routes.draw do
      root to: "home#index"
      get "ping", to: "home#ping"
    end
  end

  class HomeController < ActionController::Base
    # Track request counts for testing
    cattr_accessor :request_count, default: 0

    def index
      self.class.request_count += 1
      render plain: "TestTool index - Request ##{self.class.request_count}"
    end

    def ping
      self.class.request_count += 1
      render plain: "pong"
    end
  end

  class TestTool < RapidlyBuilt::Tool
  end

  class DefaultToolkitTest < ActionDispatch::SystemTestCase
    include ToolkitSupport
    driven_by :cuprite_desktop

    setup do
      @toolkit = RapidlyBuilt.config.default_toolkit
      @tool = TestTool.new
      @toolkit.add_tool(@tool)

      redraw_routes do
        mount TestToolEngine => "/tools/test_support", as: "tools", defaults: { app_id: "tools" }
      end

      # Reset the request counter
      HomeController.request_count = 0
    end

    test "tool is included in toolkit" do
      assert_includes @toolkit.tools, @tool
    end

    test "tool handles multiple requests" do
      visit "/tools/test_support"
      assert_text "TestTool index"
      assert_equal 1, HomeController.request_count

      visit "/tools/test_support/ping"
      assert_text "pong"
      assert_equal 2, HomeController.request_count
    end
  end

  class BuildToolkitTest < ActionDispatch::SystemTestCase
    include ToolkitSupport
    driven_by :cuprite_desktop

    setup do
      @toolkit = RapidlyBuilt.config.build_toolkit(:tools)
      @tool = TestTool.new(id: "my_id")
      @toolkit.add_tool(@tool)

      redraw_routes do
        mount TestToolEngine => "/tools/test_support", as: "tools", defaults: { app_id: "tools" }
      end

      # Reset the request counter
      HomeController.request_count = 0
    end

    test "tool is included in toolkit" do
      assert_includes @toolkit.tools, @tool
    end

    test "tool handles multiple requests" do
      visit "/tools/test_support"
      assert_text "TestTool index"
      assert_equal 1, HomeController.request_count

      visit "/tools/test_support/ping"
      assert_text "pong"
      assert_equal 2, HomeController.request_count
    end
  end
end
