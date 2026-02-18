module RapidlyBuilt
  class SearchesController < ApplicationController
    include RapidlyBuilt::UsesConsole

    def index
      respond_to do |format|
        format.json { render json: current_console.search.index.as_json }
      end
    end

    def show
      query_param = params[:query_param] || "q"

      context = RapidlyBuilt::Search::Context.new(
        query_string: params[query_param],
        console: current_console,
      )

      current_console.search.middleware.call(context) if context.query_string.present?

      respond_to do |format|
        format.html { render build_search_page(context) }
        format.json { render json: { results: context.results.map(&:to_hash) } }
      end
    end

    private

    def build_search_page(context)
      page = ui.build(RapidUI::Search::Page)

      page.static_path = current_console.search_index_path(format: :json)
      page.dynamic_path = current_console.search_path(format: :json)
      page.query = context.query_string

      context.results.each do |result|
        page.build_result(title: result.title, url: result.url, description: result.description)
      end

      page
    end
  end
end
