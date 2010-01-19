require "test_helper"

module Catalog::Service
  class DescribeRecordHandlerTest < ActiveSupport::TestCase
    include Catalog::Test::XmlTestUtil
    include Catalog::Test::HandlerTestUtil

    def setup
      @handler_clazz = DescribeRecordHandler
      @default_input = {:service => 'CSW', :version => '2.0.2'}
    end

    test 'schema language must be xml schema' do
      invalid :schemalanguage => 'BOO'
      valid :schemalanguage => 'XMLSCHEMA'
    end

    test 'output format must be application/xml' do
      invalid :outputformat => 'BOO'
      valid :outputformat => 'application/xml'
    end

    test 'namespace argument must be well formatted' do
      invalid :namespace => 'booms'
      valid :namespace => "xmlns(uri)"
    end

    test 'always return empty rsults' do
      xml = request({})
      check_xml_structure xml, ['DescribeRecordResponse']
    end
  end
end