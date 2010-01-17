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
        check_xml md.brief do
          structure 'BriefRecord', 'identifier'
          structure 'BriefRecord', 'title'
          structure 'BriefRecord', 'type'

          xpath 'id', '//dc:identifier'
          xpath 'title', '//dc:title'
          xpath 'dataset', '//dc:type'
        end
      end

      test 'can generate summary xml representation' do
        md = DCMetadata.new(input)
        check_xml md.summary do
          structure 'SummaryRecord', 'identifier'
          xpath 'id', '//dc:identifier'
        end
      end

      test 'can generate full xml representation' do
        md = DCMetadata.new(input)
        check_xml md.full do
          structure 'Record', 'identifier'
          xpath 'id', '//dc:identifier'
        end
      end

      test 'can generate xml representation using exising builder' do
        builder = Builder::XmlMarkup.new
        builder.Test do
          md = DCMetadata.new(input)
          md.full(builder)
        end
        check_xml_structure builder.target!, ['Test', 'Record', 'identifier']
      end

      private
      def input(override = {})
        valid = {:identifier => 'id', :title => 'title', :type => 'dataset'}
        valid.merge(override)
      end
    end
  end
end