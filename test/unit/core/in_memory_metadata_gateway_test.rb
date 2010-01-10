require "test_helper"

module Catalog
  module Core
    class InMemoryMetadataGatewayTest < ActiveSupport::TestCase
      def setup
        @db = Catalog::Test::MetadataDatabase.new
        @gateway = InMemoryMetadataGateway.new
      end

      test 'can return metadata by id' do
        @gateway.add(md1 = @db.create_metadata_with(:id => 'id1'))
        @gateway.add(@db.create_metadata_with(:id => 'id2'))

        assert_equal 2, @gateway.size
        assert_equal md1, @gateway.find_by_id('id1')
        assert_nil @gateway.find_by_id('invalid')
      end
      
      test 'can find metadata by filter' do
        @gateway.add(md1 = @db.create_metadata_with(:id => 'id1'))
        @gateway.add(md2 = @db.create_metadata_with(:id => 'id2'))
        @gateway.add(md3 = @db.create_metadata_with(:id => 'id3'))

        filter = flexmock('filter') do |m|
          m.should_receive(:check).with(md1).and_return(true)
          m.should_receive(:check).with(md2).and_return(true)
          m.should_receive(:check).with(md3).and_return(false)
        end
        
        assert_equal [md1,md2], @gateway.find_all_by(filter)
      end
    end
  end
end