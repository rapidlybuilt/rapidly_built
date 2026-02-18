require "test_helper"

module RapidlyBuilt
  module Search
    class ContainerTest < ActiveSupport::TestCase
      setup do
        @container = Container.new
      end

      test "#index returns a Index instance" do
        assert_instance_of Index, @container.index
      end

      test "#middleware returns a Support::Middleware::ContextStack instance" do
        assert_instance_of Support::Middleware::ContextStack, @container.middleware
      end

      test "index and middleware are independent" do
        @container.index.add_result(title: "Static Item", url: "/static")

        assert_equal 0, @container.middleware.size
        assert_equal 1, @container.index.size
      end
    end
  end
end
