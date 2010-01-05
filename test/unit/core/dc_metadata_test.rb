require "test_helper"

module Catalog
  module Core
    class DCMetadataTest < ActiveSupport::TestCase
      include Catalog::Test::XmlTestUtil

      test 'throws exception if not all elements are present' do
        assert_raise CatalogException do
          DCMetadata.new(input :title => nil)
        end
      end

      test 'can generate brief xml representation' do
        md = DCMetadata.new(input)
        xml = md.brief

        check_xml_structure xml, ['BriefRecord', 'identifier']
        check_xml_structure xml, ['BriefRecord', 'title']
        check_xml_structure xml, ['BriefRecord', 'type']
        
        check_xpath xml, 'id', '//dc:identifier'
        check_xpath xml, 'title', '//dc:title'
        check_xpath xml, 'dataset', '//dc:type'
      end

      test 'can generate summary xml representation' do
        md = DCMetadata.new(input)
        xml = md.summary
        check_xml_structure xml, ['SummaryRecord', 'identifier']
        check_xpath xml, 'id', '//dc:identifier'
      end

      test 'can generate full xml representation' do
        md = DCMetadata.new(input)
        xml = md.full
        check_xml_structure xml, ['Record', 'identifier']
        check_xpath xml, 'id', '//dc:identifier'
      end

      private
      def input(override = {})
        valid = {:identifier => 'id', :title => 'title', :type => 'dataset'}
        valid.merge(override)
      end
    end
  end
end