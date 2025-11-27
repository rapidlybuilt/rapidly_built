module RapidPlugin
  module Search
    # Represents a single search result
    #
    # @example
    #   result = RapidPlugin::Search::Result.new(
    #     title: "Ruby Gems",
    #     url: "/gems",
    #     description: "Find and install Ruby gems"
    #   )
    class Result
      attr_reader :title, :url, :description

      # @param title [String] The title of the search result
      # @param url [String] The URL of the search result
      # @param description [String, nil] Optional description
      def initialize(title:, url:, description: nil)
        @title = title.to_s
        @url = url.to_s
        @description = description&.to_s
      end

      # Check if the result has a description
      #
      # @return [Boolean]
      def has_description?
        !description.nil? && !description.empty?
      end
    end
  end
end

