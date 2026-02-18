require "test_helper"

module RapidlyBuilt
  module Integration
    class BaseTest < ActiveSupport::TestCase
      class TestIntegration < RapidlyBuilt::Integration::Base
        def call
          search.index.add_result(title: "Test", url: "/test", description: "Test description")
        end
      end

      setup do
        @console = Object.new
      end

      test "require implementing #call" do
        assert_raises NotImplementedError do
          RapidlyBuilt::Integration::Base.new(console: @console).call
        end
      end
    end
  end
end
