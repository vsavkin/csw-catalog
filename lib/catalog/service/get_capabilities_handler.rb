module Catalog
  module Service
    #noinspection ALL
    class GetCapabilitiesHandler < CswRequestHandler
      def handle
        b = Builder::XmlMarkup.new
        root_args = {'xmlns' => 'http://www.opengis.net/ows/1.1',
                     'xmlns:ows' => 'http://www.opengis.net/ows/1.1',
                     'xmlns:xlink' => 'http://www.w3.org/2001/XMLSchema-instance',
                     'xmlns:xsi' => 'http://www.w3.org/1999/xlink',
                     'xsi:schemaLocation' => 'http://www.opengis.net/ows/1.1 ows.xsd',
                     'version' => '1.2.0'}

        b.Capabilities root_args do
          add_service_identification b
          add_service_provider b
          add_operations_metadata b
          add_filter_capabilities b
        end
      end

      private
      def add_service_identification(b)
        b.ServiceIdentification do
          b.Title 'TIG', 'xml:lang' => 'en'
          b.Abstract 'CS-W 2.0.2/AP ISO19115/19139 for service, datasets and applications'
          b.Keywords do
            b.Keyword 'TIG'
            b.Keyword 'ISO-19115'
            b.Keyword 'ISO-19119'            
          end
          b.ServiceType 'OGC:CSW'
          b.ServiceTypeVersion '2.0.2'
          b.Fees 'None'
          b.AccessConstraints 'None'
        end
      end

      def add_service_provider(b)
        b.ServiceProvider do
          b.ProviderName 'TIG'
          b.ServiceContact do
            b.IndividualName 'Victor Savkin, Software Developer'
            b.PositionName 'Computer Scienctist'
            b.ContactInfo do
              b.ElectronicMailAddress 'avix1000@gmail.com'
            end
          end
        end
      end

      def add_operations_metadata(b)
        b.OperationsMetadata do
          add_operation b, 'GetCapabilities'
          add_operation b, 'DescribeRecord'
          add_operation b, 'GetRecords'
        end
      end

      def add_operation(b, op_name)
        url = 'http://localhost:3000/?'
        b.Operation :name => op_name do
          b.DCP do
            b.HTTP do
              b.Get 'xlink:href' => url
            end
          end
          b.Parameter :name => 'Format' do
            b.Value 'text/xml'           
          end
        end
      end

      def add_filter_capabilities(b)
        
      end
    end
  end
end