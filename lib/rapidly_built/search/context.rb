module RapidlyBuilt
  module Search
    # Context object that flows through the search middleware stack
    #
    # Contains the search query string, results, and the toolkit instance.
    # Each search middleware receives a Context and can add, modify, or filter results.
    #
    # @example
    #   context = RapidlyBuilt::Search::Context.new(query_string: "ruby gems", toolkit: toolkit)
    #   context.add_result(title: "Result 1", url: "/result1")
    #   context.results # => [<Result>, ...]
    #   context.results.size # => 1
    #   context.results.select! { |r| r.title == "Result 1" }
    class Context
      attr_reader :query_string
      attr_reader :results
      attr_reader :console

      # @param query_string [String] The search query string
      # @param console [RapidlyBuilt::Console::Base] The console instance
      def initialize(query_string:, console:)
        @query_string = query_string.to_s
        @console = console
        @results = []
      end

      # Add a result to the collection
      #
      # @param title [String] The title of the result
      # @param url [String] The URL of the result
      # @param description [String, nil] Optional description
      # @return [Result] The created result
      def add_result(title:, url:, description: nil)
        result = Result.new(
          title: title,
          url: url,
          description: description
        )
        @results << result
        result
      end
    end
  end
end
