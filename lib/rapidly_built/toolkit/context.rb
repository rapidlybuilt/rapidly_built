module RapidlyBuilt
  module Toolkit
    class Context
      attr_reader :toolkit
      attr_reader :ui
      attr_reader :controller

      with_options to: :ui do
        delegate :layout
        delegate :layout=
      end

      with_options to: :controller do
        delegate :view_context
      end

      def initialize(toolkit:, ui:, controller:)
        @toolkit = toolkit
        @ui = ui
        @controller = controller
      end
    end
  end
end
