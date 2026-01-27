require "test_helper"

module RapidlyBuilt
  module Search
    class ContainerTest < ActiveSupport::TestCase
      setup do
        @container = Container.new
      end

      test "#static returns a Static instance" do
        assert_instance_of Static, @container.static
      end

      test "#static returns the same instance" do
        static1 = @container.static
        static2 = @container.static

        assert_same static1, static2
      end

      test "#dynamic returns a Middleware instance" do
        assert_instance_of Toolkit::Middleware, @container.dynamic
      end

      test "#dynamic returns the same instance" do
        dynamic1 = @container.dynamic
        dynamic2 = @container.dynamic

        assert_same dynamic1, dynamic2
      end

      test "static and dynamic are independent" do
        @container.static.add(title: "Static Item", url: "/static")

        # Dynamic middleware should be empty
        assert_equal 0, @container.dynamic.size

        # Static should have the item
        assert_equal 1, @container.static.size
      end
    end
  end
end
