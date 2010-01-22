require "test_helper"

module Catalog::Core
  class SchemaValidatorTest < ActiveSupport::TestCase
    def setup
      @db = Catalog::Test::MetadataDatabase.new
      @validator = IsoSchemaValidator.new
    end

    test 'validator does nothing if xml is correct' do
      md = @db.create_metadata_with(:id => 'myid')
      @validator.validate(md)
    end

    test 'validator throws exception if xml is incorrect' do
      assert_raise CatalogException do
        @validator.validate ISOMetadata.new(1, '<a>b</a>')
      end
    end
  end
end