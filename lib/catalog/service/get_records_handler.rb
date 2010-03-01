module Catalog::Service
  #noinspection ALL
  class GetRecordsHandler < CswRequestHandler
    include Catalog::Core::Schemas

    def initialize(input, gateway)
      @gateway = gateway
      super input
    end

    def handle
      params[:resulttype] ||= 'hits'
      params[:outputformat] ||= 'application/xml'
      params[:outputschema] ||= CSW
      params[:startposition] ||= 1
      params[:maxrecords] ||= 10

      check_parameter :outputformat, 'application/xml'
      check_parameter :resulttype, 'hits', 'results'
      check_parameter :typenames, 'csw:record'
      check_parameter :outputschema, CSW

      namespaces = parse_namespaces
      metadata = retrive_metadata
      metadata_return = metadata_to_return(metadata)

      generate_response(metadata, metadata_return)
    end

    private
    def retrive_metadata
      if params[:constraint]
        filter = Filter.parse(params[:constraint])
        @gateway.find_all_by(filter)
      else
        @gateway.all
      end
    end

    def metadata_to_return(metadata)
      return [] unless params[:resulttype] == 'results'
      start = params[:startposition].to_i - 1
      max = params[:maxrecords].to_i
      metadata[start...start + max]
    end

    def next_record(metadata)
      start = params[:startposition].to_i
      max = params[:maxrecords].to_i
      if metadata.size <= start + max  - 1
        0
      else
        start + max
      end
    end

    def generate_response(metadata, metadata_return)
      builder = Builder::XmlMarkup.new
      root_args = {'xmlns' => CSW,
                   'xmlns:csw' => CSW,
                   'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema'}

      builder.GetRecordsResponse root_args do
        builder.SearchStatus :timestamp => Time.now

        search_response_args = {:elementSet => 'full',
                                :recordSchema => CSW,
                                :numberOfRecordsMatched => metadata.size,
                                :numberOfRecordsReturned => metadata_return.size,
                                :nextRecord => next_record(metadata)}
        builder.SearchResults search_response_args do
          serialize_metadata builder, metadata_return
        end
      end
    end

    def serialize_metadata(builder, metadata)
      metadata.each do |m|
        dc = m.to_dublin_core
        dc.full(builder)
      end
    end
  end
end