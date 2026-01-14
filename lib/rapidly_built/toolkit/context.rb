module RapidlyBuilt
  module Toolkit
    class Context
      attr_reader :toolkit
      attr_reader :ui

      with_options to: :ui do
        delegate :layout
        delegate :layout=
      end

      def initialize(toolkit:, ui:)
        @toolkit = toolkit
        @ui = ui
      end
    end
  end
end
