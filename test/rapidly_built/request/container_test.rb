require "test_helper"

module RapidlyBuilt
  module Request
    class ContainerTest < ActiveSupport::TestCase
      setup do
        @container = Container.new
      end

      test "#middleware returns a Support::Middleware::ContextStack instance" do
        assert_instance_of Support::Middleware::ContextStack, @container.middleware
      end
    end
  end
end
