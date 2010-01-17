module Catalog
  module Service
    class HandlerManager
      def initialize(gateway)
        @gateway = gateway
        @handlers = {:getcapabilities => GetCapabilitiesHandler,
                     :describerecord => DescribeRecordHandler,
                     :getrecords => GetRecordsHandler}
        @exception_formatter = XmlExceptionFormatter.new
      end

      def process(params)
        request = params[:request]
        raise 'Request parameter must be specified' if request.nil?

        request_sym = request.downcase.to_sym
        handler_type = @handlers[request_sym]
        raise "Request type '#{request}' is not supported" if handler_type.nil?

        if request_sym == :getrecords
          handler_type.new(params, @gateway).handle
        else
          handler_type.new(params).handle          
        end
      rescue Exception => e
        @exception_formatter.format(e)
      end
    end
  end
end