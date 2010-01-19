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

      check_parameter :outputformat, 'application/xml'
      check_parameter :resulttype, 'hits', 'results'
      check_parameter :typenames, 'csw:record'
      check_parameter :outputschema, CSW

      namespaces = parse_namespaces

      if params[:constraint]
        filter = Filter.parse(params[:constraint])
        metadata = @gateway.find_all_by(filter)
      else
        metadata = @gateway.all
      end
      metadata_return = params[:resulttype] == 'results' ? metadata : []

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
                                :nextRecord => 0}
        builder.SearchResults search_response_args do
          serialize_metadata builder, metadata_return
        end
      end
    end

    private
    def serialize_metadata(builder, metadata)
      metadata.each do |m|
        dc = m.to_dublin_core
        dc.full(builder)
      end
    end
  end
end