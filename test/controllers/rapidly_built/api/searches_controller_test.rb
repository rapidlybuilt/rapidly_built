require "test_helper"

module RapidlyBuilt
  module Api
    class SearchesControllerTest < ActionController::TestCase
      tests RapidlyBuilt::Api::SearchesController

      # Test middleware for dynamic search
      class TestSearchMiddleware
        attr_reader :called_with_context

        def initialize(**options)
          @called_with_context = nil
        end

        def call(context)
          @called_with_context = context
          context.add_result(title: "Dynamic Result", url: "/dynamic", description: "Found via search")
          context
        end
      end

      setup do
        RapidlyBuilt.config.toolkits.new(:default)
        @toolkit = RapidlyBuilt.config.toolkits.find!(:default)

        # Set up routes for the controller
        @routes = ActionDispatch::Routing::RouteSet.new
        @routes.draw do
          get "static", to: "rapidly_built/api/searches#static"
          get "dynamic", to: "rapidly_built/api/searches#dynamic"
        end
      end

      test "static returns empty array when no items configured" do
        get :static

        assert_response :success
        assert_equal [], response.parsed_body
      end

      test "static returns configured search items" do
        @toolkit.search.static.add(title: "Button", url: "/components/button", description: "Interactive button")
        @toolkit.search.static.add(title: "Modal", url: "/components/modal")

        get :static

        assert_response :success

        json = response.parsed_body
        assert_equal 2, json.size
        assert_equal "Button", json[0]["title"]
        assert_equal "/components/button", json[0]["url"]
        assert_equal "Interactive button", json[0]["description"]
        assert_equal "Modal", json[1]["title"]
        assert_equal "/components/modal", json[1]["url"]
      end

      test "dynamic returns empty results when no query" do
        get :dynamic

        assert_response :success
        assert_equal({ "results" => [] }, response.parsed_body)
      end

      test "dynamic calls middleware with query string" do
        @toolkit.search.dynamic.use(TestSearchMiddleware)

        get :dynamic, params: { q: "test query" }

        assert_response :success

        json = response.parsed_body
        assert_equal 1, json["results"].size
        assert_equal "Dynamic Result", json["results"][0]["title"]
        assert_equal "/dynamic", json["results"][0]["url"]
        assert_equal "Found via search", json["results"][0]["description"]

        # Verify middleware was called with correct context
        middleware_entry = @toolkit.search.dynamic.entries.first
        context = middleware_entry.instance.called_with_context

        assert_equal "test query", context.query_string
        assert_equal @toolkit, context.toolkit
      end

      test "dynamic uses custom query_param" do
        @toolkit.search.dynamic.use(TestSearchMiddleware)

        get :dynamic, params: { query_param: "search", search: "custom query" }

        assert_response :success

        middleware_entry = @toolkit.search.dynamic.entries.first
        context = middleware_entry.instance.called_with_context

        assert_equal "custom query", context.query_string
      end

      test "dynamic does not call middleware when query is blank" do
        @toolkit.search.dynamic.use(TestSearchMiddleware)

        get :dynamic, params: { q: "" }

        assert_response :success
        assert_equal({ "results" => [] }, response.parsed_body)

        # Middleware should not have been called
        middleware_entry = @toolkit.search.dynamic.entries.first
        assert_nil middleware_entry.instance.called_with_context
      end
    end
  end
end
