module RapidlyBuilt
  module Search
    # Static search index for items that are searched client-side
    #
    # Static items are fetched once and cached in the browser, allowing
    # instant search results without server round-trips.
    #
    # @example
    #   static = RapidlyBuilt::Search::Static.new
    #   static.add(title: "Button", url: "/components/button", description: "Interactive button")
    #   static.items # => [<Result>, ...]
    #   static.as_json # => [{ title: "Button", url: "/components/button", description: "..." }]
    class Static
      def initialize
        @items = []
      end

      # Add a static search item
      #
      # @param title [String] The title of the search result
      # @param url [String] The URL of the search result
      # @param description [String, nil] Optional description
      # @return [Result] The created result
      def add(title:, url:, description: nil)
        result = Result.new(title: title, url: url, description: description)
        @items << result
        result
      end

      # Get all static search items
      #
      # @return [Array<Result>] A copy of the items array
      def items
        @items.dup
      end

      # Get the number of items in the index
      #
      # @return [Integer]
      def size
        @items.size
      end

      # Check if the index is empty
      #
      # @return [Boolean]
      def empty?
        @items.empty?
      end

      # Serialize items to JSON-compatible format
      #
      # @return [Array<Hash>] Array of item hashes
      def as_json(*)
        @items.map { |item|
          { title: item.title, url: item.url, description: item.description }
        }
      end
    end
  end
end
