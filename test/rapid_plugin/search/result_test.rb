require "test_helper"

module RapidPlugin
  module Search
    class ResultTest < ActiveSupport::TestCase
      test "initializes with required attributes" do
        result = Result.new(title: "Test", url: "/test")
        assert_equal "Test", result.title
        assert_equal "/test", result.url
      end

      test "initializes with optional description" do
        result = Result.new(title: "Test", url: "/test", description: "A test result")
        assert_equal "A test result", result.description
      end

      test "description defaults to nil" do
        result = Result.new(title: "Test", url: "/test")
        assert_nil result.description
      end

      test "#has_description? returns true when description is present" do
        result = Result.new(title: "Test", url: "/test", description: "A description")
        assert result.has_description?
      end

      test "#has_description? returns false when description is nil" do
        result = Result.new(title: "Test", url: "/test")
        assert_not result.has_description?
      end

      test "#has_description? returns false when description is empty" do
        result = Result.new(title: "Test", url: "/test", description: "")
        assert_not result.has_description?
      end

      test "converts title and url to strings" do
        result = Result.new(title: 123, url: 456)
        assert_equal "123", result.title
        assert_equal "456", result.url
      end
    end
  end
end

