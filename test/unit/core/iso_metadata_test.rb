require "test_helper"

module Catalog
  module Core
    class ISOMetadataTest < ActiveSupport::TestCase
      def setup
        @db = Catalog::Test::MetadataDatabase.new
      end

      test 'can return dc metadata with required properties if it has them' do
        md = @db.create_metadata_with(:id => 'myid', :title => 'mytitle')
        p md.xml
        dc = md.to_dublin_core

        assert_equal 'myid', dc[:identifier]
        assert_equal 'mytitle', dc[:title]
      end
    end
  end
end