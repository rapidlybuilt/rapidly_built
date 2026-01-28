require "test_helper"

class RapidlyBuiltTest < ActiveSupport::TestCase
  class TestTool < RapidlyBuilt::Tool::Base
    def connect(app)
    end
  end

  test "it has a version number" do
    assert RapidlyBuilt::VERSION
  end

  test "register_tool! adds tool to default toolkit" do
    tool = TestTool.new
    RapidlyBuilt.register_tool!(tool)
    assert_equal [ tool ], RapidlyBuilt.config.default_toolkit.tools
  end
end
