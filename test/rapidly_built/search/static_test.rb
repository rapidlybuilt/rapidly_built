require "test_helper"

module RapidlyBuilt
  module Search
    class StaticTest < ActiveSupport::TestCase
      setup do
        @static = Static.new
      end

      test "initializes with empty items" do
        assert_equal [], @static.items
        assert @static.empty?
        assert_equal 0, @static.size
      end

      test "#add creates a Result and adds it to items" do
        result = @static.add(title: "Button", url: "/components/button")

        assert_instance_of Result, result
        assert_equal "Button", result.title
        assert_equal "/components/button", result.url
        assert_nil result.description
        assert_equal 1, @static.size
      end

      test "#add with description" do
        result = @static.add(
          title: "Card",
          url: "/components/card",
          description: "Content container"
        )

        assert_equal "Content container", result.description
      end

      test "#add can be chained" do
        @static.add(title: "A", url: "/a")
        @static.add(title: "B", url: "/b")
        @static.add(title: "C", url: "/c")

        assert_equal 3, @static.size
        assert_equal %w[A B C], @static.items.map(&:title)
      end

      test "#items returns a copy" do
        @static.add(title: "Test", url: "/test")
        items = @static.items
        items.clear

        assert_equal 1, @static.size
      end

      test "#empty? returns true when no items" do
        assert @static.empty?
      end

      test "#empty? returns false when items exist" do
        @static.add(title: "Test", url: "/test")
        refute @static.empty?
      end

      test "#as_json returns array of hashes" do
        @static.add(title: "Button", url: "/button", description: "A button")
        @static.add(title: "Card", url: "/card")

        json = @static.as_json

        assert_equal 2, json.size
        assert_equal({ title: "Button", url: "/button", description: "A button" }, json[0])
        assert_equal({ title: "Card", url: "/card", description: nil }, json[1])
      end

      test "#as_json returns empty array when no items" do
        assert_equal [], @static.as_json
      end
    end
  end
end
