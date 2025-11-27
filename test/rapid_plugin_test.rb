require "test_helper"

class RapidPluginTest < ActiveSupport::TestCase
  class TestPlugin < RapidPlugin::Base
    def connect(app)
    end

    def mount(routes)
    end
  end

  test "it has a version number" do
    assert RapidPlugin::VERSION
  end

  test "register! adds plugin to default application" do
    plugin = TestPlugin.new
    RapidPlugin.register!(plugin)
    assert_equal [ plugin ], RapidPlugin.config.default_application.plugins
  end
end
