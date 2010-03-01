require "test_helper"

module Catalog::Core
  class ISOMetadataTest < ActiveSupport::TestCase
    include Catalog::Test::XmlTestUtil
    
    def setup
      @db = Catalog::Test::MetadataDatabase.new
    end

    test 'can return dc metadata with required properties if it has them' do
      md = @db.create_metadata_with(:id => 'myid', :title => 'mytitle')
      dc = md.to_dublin_core

      assert_equal 'myid', dc[:identifier]
      assert_equal 'mytitle', dc[:title]
    end

    test 'can retrieve queriable fields from metadata' do
      md = @db.create_metadata_with(:id => 'myid', :title => 'mytitle',
                                    :abstract => 'myabstract', :extent => Envelope.parse('0 0 5 5'))

      assert_equal 'mytitle', md.field('Title')
      assert_equal 'myid', md.field('Identifier')
      assert_equal 'myabstract', md.field('Abstract')
      assert_equal nil, md.field('Subject')      
      assert_equal 'mytitle myabstract', md.field('AnyText')
      assert_equal Envelope.parse('0 0 5 5'), md.field('BoundingBox')
      assert_nil md.field('SomeText')
    end

    test 'can produce a new metadata using existing one and new field values' do
      md1 = @db.create_metadata_with(:id => 'myid', :title => 'mytitle',
                                    :abstract => 'myabstract', :extent => Envelope.parse('0 0 5 5'))

      md2 = @db.create_metadata_with(:id => 'myid2', :title => 'mytitle2',
                                    :abstract => 'myabstract', :extent => Envelope.parse('0 0 5 5'))

      generated_md2 = md1.merge(:identifier => 'myid2', :title => 'mytitle2')
      check_xml_equals md2.xml, generated_md2.xml
    end
  end
end