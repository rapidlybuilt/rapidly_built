require "test_helper"

module RapidlyBuilt
  module Search
    class ContextTest < ActiveSupport::TestCase
      setup do
        @toolkit = Object.new
        @context = Context.new(query_string: "test", toolkit: @toolkit)
      end

      test "initializes with query_string and toolkit" do
        assert_equal "test", @context.query_string
        assert_equal @toolkit, @context.toolkit
      end

      test "initializes with empty results array" do
        assert_equal [], @context.results
      end

      test "#add_result creates and adds a result" do
        result = @context.add_result(title: "Test", url: "/test")
        assert_instance_of Result, result
        assert_equal 1, @context.results.size
        assert_equal result, @context.results.first
      end

      test "#add_result includes description when provided" do
        result = @context.add_result(title: "Test", url: "/test", description: "A test")
        assert_equal "A test", result.description
      end
    end
  end
end
