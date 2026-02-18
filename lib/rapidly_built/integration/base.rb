module RapidlyBuilt
  module Integration
    class Base
      attr_accessor :console

      with_options to: :console do
        delegate :search
        delegate :request
        delegate :helpers
      end

      def apply_to(console)
      end
    end
  end
end
