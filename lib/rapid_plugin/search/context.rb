module RapidPlugin
  module Search
    # Context object that flows through the search middleware stack
    #
    # Contains the search query string, results, and the application instance.
    # Each search middleware receives a Context and can add, modify, or filter results.
    #
    # @example
    #   context = RapidPlugin::Search::Context.new(query_string: "ruby gems", application: app)
    #   context.add_result(title: "Result 1", url: "/result1")
    #   context.results # => [<Result>, ...]
    #   context.results.size # => 1
    #   context.results.select! { |r| r.title == "Result 1" }
    class Context
      attr_reader :query_string, :results, :application

      # @param query_string [String] The search query string
      # @param application [RapidPlugin::Application] The application instance
      def initialize(query_string:, application:)
        @query_string = query_string.to_s
        @application = application
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

