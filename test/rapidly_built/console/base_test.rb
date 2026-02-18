require "test_helper"

module RapidlyBuilt
  module Console
    class BaseTest < ActiveSupport::TestCase
      class TestConsole < RapidlyBuilt::Console::Base
        def build
          search.index.add_result(title: "Test", url: "/test", description: "Test description")
        end
      end

      test "require implementing #build to initialize" do
        assert_raises NotImplementedError do
          RapidlyBuilt::Console::Base.new(id: :test)
        end
      end
    end
  end
end
