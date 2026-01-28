require "test_helper"

class RapidlyBuiltTest < ActiveSupport::TestCase
  class TestTool < RapidlyBuilt::Tool::Base
    def connect(app)
    end
  end

  test "it has a version number" do
    assert RapidlyBuilt::VERSION
  end
end
