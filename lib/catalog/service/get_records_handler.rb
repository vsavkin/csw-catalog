module Catalog
  module Service
    
    #noinspection ALL
    class GetRecordsHandler < CswRequestHandler
      def handle
        result_type = params[:resulttype] || 'hits'
        start_position = params[:startposition].to_i || 1
        max_records = params[:maxrecords].to_i || 10
        type = params[:maxrecords].to_i || 10

      end
    end
  end
end