module Catalog
  module Test
    module HandlerTestUtil

      def valid(override, args = nil)
        input = (args || @default_input).merge(override)
        create_handler(input).handle
      end

      def invalid(override, args = nil)
        input = (args || @default_input).merge(override)
        assert_raise Catalog::Service::CswRequestValidationException do
          create_handler(input).handle
        end
      end

      def request(override)
        input = @default_input.merge(override)
        create_handler(input).handle
      end

      private
      def create_handler(input)
        if @default_args
          args = [input] + @default_args
          @handler_clazz.new(*args)
        else
          @handler_clazz.new(input)
        end
      end
    end
  end
end