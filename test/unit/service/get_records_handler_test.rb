require "test_helper"

module Catalog::Service
  class GetRecordsHandlerTest < ActiveSupport::TestCase
    include Catalog::Test::XmlTestUtil
    include Catalog::Test::HandlerTestUtil
    include Catalog::Core::Schemas

    #http://www.opengis.net/cat/csw/2.0.2 - schema support only this
    #csw:Record - support only this

    def setup
      @gateway = flexmock('gateway')
      @db = Catalog::Test::MetadataDatabase.new

      @handler_clazz = GetRecordsHandler
      @default_input = {:service => 'CSW', :version => '2.0.2', :typenames => 'csw:Record'}
      @default_args = [@gateway]
    end

    test 'output format must be application xml' do
      @gateway.should_receive(:all).and_return([])
      invalid :outputformat => 'BOO'
      valid :outputformat => 'application/xml'
    end

    test 'namespace argument must be well formatted' do
      @gateway.should_receive(:all).and_return([])
      invalid :namespace => 'booms'
      valid :namespace => 'xmlns(uri)'
    end

    test 'result type can be hits results' do
      @gateway.should_receive(:all).and_return([])
      invalid :resulttype => 'booms'
      valid :resulttype => 'hits'
      valid :resulttype => 'results'
      invalid :resulttype => 'validate'
    end

    test 'type names must be presented' do
      @gateway.should_receive(:all).and_return([])
      invalid :typenames => nil
      valid :typenames => 'csw:Record'
    end

    test 'hits request return the number of found items' do
      md = @db.create_metadata_with(:title => 'my title')
      @gateway.should_receive(:all).once.and_return([md])

      response = request :resulttype => 'hits'
      check_xml response do
        structure 'GetRecordsResponse', 'SearchStatus'
        structure 'GetRecordsResponse', 'SearchResults'
        xpath '1', '//SearchResults', 'numberOfRecordsMatched'
        xpath '0', '//SearchResults', 'numberOfRecordsReturned'
      end
    end

    test 'results request return the number of found items' do
      md = @db.create_metadata_with(:title => 'my title')
      @gateway.should_receive(:all).once.and_return([md])

      response = request :resulttype => 'results'
      check_xml response do
        structure 'GetRecordsResponse', 'SearchStatus'
        structure 'GetRecordsResponse', 'SearchResults', 'Record'
        xpath '1', '//SearchResults', 'numberOfRecordsMatched'
        xpath '1', '//SearchResults', 'numberOfRecordsReturned'
        xpath '0', '//SearchResults', 'nextRecord'
        xpath CSW, '//SearchResults', 'recordSchema'
        xpath 'full', '//SearchResults', 'elementSet'
      end
    end

    test 'filter can be used in get records requests' do
      md = @db.create_metadata_with(:title => 'my title')
      filter = Filter.create(PropertyIsLike.new('AnyText', 'boo'))
      @gateway.should_receive(:find_all_by).with(filter).once.and_return([md])
      request :resulttype => 'hits', :constraint => filter.to_xml
    end
  end
end