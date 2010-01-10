module Catalog
  module Service
    class HandlerManager
      def initialize
        @handlers = {:getcapabilities => GetCapabilitiesHandler}
        @exception_formatter = XmlExceptionFormatter.new
      end

      def process(params)
        request = params[:request]
        raise 'Request parameter must be specified' if request.nil?

        handler_type = @handlers[request.downcase.to_sym]
        raise "Request type '#{request}' is not supported" if handler_type.nil?

        handler_type.new(params).handle
      rescue Exception => e
        @exception_formatter.format(e)
      end
    end
  end
end