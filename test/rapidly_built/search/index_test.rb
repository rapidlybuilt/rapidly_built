require "test_helper"

module RapidlyBuilt
  module Search
    class IndexTest < ActiveSupport::TestCase
      setup do
        @index = Index.new
      end

      test "initializes with empty items" do
        assert_equal [], @index.items
        assert @index.empty?
        assert_equal 0, @index.size
      end

      test "#add creates a Result and adds it to items" do
        result = @index.add_result(title: "Button", url: "/components/button")

        assert_instance_of Result, result
        assert_equal "Button", result.title
        assert_equal "/components/button", result.url
        assert_nil result.description
        assert_equal 1, @index.size
      end

      test "#add with description" do
        result = @index.add_result(
          title: "Card",
          url: "/components/card",
          description: "Content container"
        )

        assert_equal "Content container", result.description
      end

      test "#add can be chained" do
        @index.add_result(title: "A", url: "/a")
        @index.add_result(title: "B", url: "/b")
        @index.add_result(title: "C", url: "/c")

        assert_equal 3, @index.size
        assert_equal %w[A B C], @index.items.map(&:title)
      end

      test "#items returns a copy" do
        @index.add_result(title: "Test", url: "/test")
        items = @index.items
        items.clear

        assert_equal 1, @index.size
      end

      test "#empty? returns true when no items" do
        assert @index.empty?
      end

      test "#empty? returns false when items exist" do
        @index.add_result(title: "Test", url: "/test")
        refute @index.empty?
      end

      test "#as_json returns array of hashes" do
        @index.add_result(title: "Button", url: "/button", description: "A button")
        @index.add_result(title: "Card", url: "/card")

        json = @index.as_json

        assert_equal 2, json.size
        assert_equal({ title: "Button", url: "/button", description: "A button" }, json[0])
        assert_equal({ title: "Card", url: "/card", description: nil }, json[1])
      end

      test "#as_json returns empty array when no items" do
        assert_equal [], @index.as_json
      end
    end
  end
end
