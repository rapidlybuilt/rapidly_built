module RapidlyBuilt
  module Api
    class SearchesController < ApplicationController
      include RapidlyBuilt::Setup

      def static
        render json: rapidly_built.toolkit.search.static.as_json
      end

      def dynamic
        query_param = params[:query_param] || "q"

        context = RapidlyBuilt::Search::Context.new(
          query_string: params[query_param],
          toolkit: rapidly_built.toolkit,
        )

        rapidly_built.toolkit.search.dynamic.call(context) if context.query_string.present?
        render json: { results: context.results.map(&:to_hash) }
      end
    end
  end
end
