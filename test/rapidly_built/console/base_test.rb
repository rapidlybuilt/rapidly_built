require "test_helper"

module RapidlyBuilt
  module Console
    class BaseTest < ActiveSupport::TestCase
      class TestConsole < RapidlyBuilt::Console::Base
        def initialize(**kwargs)
          super(**kwargs)
          search.index.add_result(title: "Test", url: "/test", description: "Test description")
        end
      end
    end
  end
end
