require "test_helper"

class RapidlyBuiltTest < ActiveSupport::TestCase
  class TestPlugin < RapidlyBuilt::Base
    def connect(app)
    end

    def mount(routes)
    end
  end

  test "it has a version number" do
    assert RapidlyBuilt::VERSION
  end

  test "register! adds plugin to default application" do
    plugin = TestPlugin.new
    RapidlyBuilt.register!(plugin)
    assert_equal [ plugin ], RapidlyBuilt.config.default_application.plugins
  end
end
