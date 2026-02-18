module RapidlyBuilt
  module Integration
    class Base
      attr_accessor :console

      attr_reader :engine

      with_options to: :console do
        delegate :search
        delegate :request
      end

      def initialize(console:, engine: nil)
        @console = console
        @engine = engine
      end

      def call
        raise NotImplementedError, "Subclasses must implement #call"
      end

      private

      def helpers
        @helpers ||= (engine || Rails.application).routes.url_helpers
      end
    end
  end
end
