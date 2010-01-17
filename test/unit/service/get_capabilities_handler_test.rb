require "test_helper"

module Catalog
  module Service
    class GetCapabilitiesHandlerTest < ActiveSupport::TestCase
      include Catalog::Test::XmlTestUtil

      def setup
        @handler = GetCapabilitiesHandler.new(:service => 'csw', :version => '2.0.2')
      end

      test 'get capabilities' do
        xml = @handler.handle
        check_xml xml do
          structure 'Capabilities', 'ServiceIdentification'
          structure 'Capabilities', 'ServiceProvider'
          structure 'Capabilities', 'OperationsMetadata'
          structure 'Capabilities', 'Filter_Capabilities'          
        end
      end
    end
  end
end