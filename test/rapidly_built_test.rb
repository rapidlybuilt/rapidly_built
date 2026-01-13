require "test_helper"

class RapidlyBuiltTest < ActiveSupport::TestCase
  class TestTool < RapidlyBuilt::Base
    def connect(app)
    end

    def mount(routes)
    end
  end

  test "it has a version number" do
    assert RapidlyBuilt::VERSION
  end

  test "register_tool! adds tool to default application" do
    tool = TestTool.new
    RapidlyBuilt.register_tool!(tool)
    assert_equal [ tool ], RapidlyBuilt.config.default_application.tools
  end
end
