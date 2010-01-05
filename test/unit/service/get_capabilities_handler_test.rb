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
        check_xml_structure xml, ['Capabilities', 'ServiceIdentification']
        check_xml_structure xml, ['Capabilities', 'ServiceProvider']
        check_xml_structure xml, ['Capabilities', 'OperationsMetadata']
      end
    end
  end
end