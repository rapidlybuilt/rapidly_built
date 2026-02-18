require "test_helper"

module RapidlyBuilt
  class SearchesControllerTest < ActionController::TestCase
    tests RapidlyBuilt::SearchesController
    include ConsoleSupport

    # Test middleware for dynamic search. Works with Search middleware stack:
    # context is set via context=, then call is invoked with no args.
    class TestSearchMiddleware
      attr_accessor :context
      attr_reader :called_with_context

      def initialize(**options)
        @called_with_context = nil
      end

      def call
        @called_with_context = context
        context.add_result(title: "Dynamic Result", url: "/dynamic", description: "Found via search")
      end
    end

    setup do
      @routes = ActionDispatch::Routing::RouteSet.new
      @routes.draw do
        get "search/index", to: "rapidly_built/searches#index", defaults: { console_id: "application" }
        get "search", to: "rapidly_built/searches#show", defaults: { console_id: "application" }
      end
    end

    teardown do
      unstub_console
    end

    test "index returns empty array when no items configured" do
      stub_test_console
      get :index, format: :json

      assert_response :success
      assert_equal [], response.parsed_body
    end

    test "index returns configured search items" do
      stub_test_console do |console|
        console.search.index.add_result(title: "Button", url: "/components/button", description: "Interactive button")
        console.search.index.add_result(title: "Modal", url: "/components/modal")
      end

      get :index, format: :json

      assert_response :success

      json = response.parsed_body
      assert_equal 2, json.size
      assert_equal "Button", json[0]["title"]
      assert_equal "/components/button", json[0]["url"]
      assert_equal "Interactive button", json[0]["description"]
      assert_equal "Modal", json[1]["title"]
      assert_equal "/components/modal", json[1]["url"]
    end

    test "show returns empty results when no query" do
      stub_test_console do |console|
        console.search.middleware.use(TestSearchMiddleware)
      end

      get :show, format: :json

      assert_response :success
      assert_equal({ "results" => [] }, response.parsed_body)
    end

    test "show calls middleware with query string" do
      stub_test_console do |console|
        @console = console
        console.search.middleware.use(TestSearchMiddleware)
      end

      get :show, params: { q: "test query" }, format: :json

      assert_response :success

      json = response.parsed_body
      assert_equal 1, json["results"].size
      assert_equal "Dynamic Result", json["results"][0]["title"]
      assert_equal "/dynamic", json["results"][0]["url"]
      assert_equal "Found via search", json["results"][0]["description"]

      middleware_entry = @console.search.middleware.entries.first
      context = middleware_entry.instance.called_with_context

      assert_equal "test query", context.query_string
      assert_equal @console, context.console
    end

    test "show uses custom query_param" do
      stub_test_console do |console|
        @console = console
        console.search.middleware.use(TestSearchMiddleware)
      end

      get :show, params: { query_param: "search", search: "custom query" }, format: :json

      assert_response :success

      middleware_entry = @console.search.middleware.entries.first
      context = middleware_entry.instance.called_with_context

      assert_equal "custom query", context.query_string
    end

    test "show does not call middleware when query is blank" do
      stub_test_console do |console|
        @console = console
        console.search.middleware.use(TestSearchMiddleware)
      end

      get :show, params: { q: "" }, format: :json

      assert_response :success
      assert_equal({ "results" => [] }, response.parsed_body)

      middleware_entry = @console.search.middleware.entries.first
      assert_nil middleware_entry.instance.called_with_context
    end
  end
end
