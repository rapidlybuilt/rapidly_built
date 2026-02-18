module RapidlyBuilt
  module Console
    class Base
      def modules
        @modules ||= []
      end

      private

      def integrate(my_module)
        modules << my_module
      end
    end
  end
end
