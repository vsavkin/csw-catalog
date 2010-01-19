require "test_helper"

module Catalog::Core
  class ISOMetadataTest < ActiveSupport::TestCase
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
      assert_equal 'mytitle myabstract', md.field('AnyText')
      assert_equal Envelope.parse('0 0 5 5'), md.field('BoundingBox')
      assert_nil md.field('SomeText')
    end
  end
end