module Catalog
  module Service
    #noinspection ALL
    class DescribeRecordHandler < CswRequestHandler
      def handle
        super
        params[:schemalanguage] ||= 'xmlschema'
        params[:outputformat] ||= 'application/xml'
        check_parameter :schemalanguage, 'xmlschema'
        check_parameter :outputformat, 'application/xml'
        processed = parse_namespaces

        b = Builder::XmlMarkup.new
        root_args = {'xmlns' => 'http://www.opengis.net/cat/csw',
                     'xmlns:csw' => 'http://www.opengis.net/cat/csw',
                     'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema'}

        b.DescribeRecordResponse root_args do
          #do something
        end
      end
    end
  end
end