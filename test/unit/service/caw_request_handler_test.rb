require "test_helper"

module Catalog::Service
  class CswRequestHanderTest < ActiveSupport::TestCase
    test 'request handler throws exception if service is not specified property' do
      ex = assert_raise CswRequestValidationException do
        CswRequestHandler.new(input :service => "BOOM!").handle
      end
      assert_equal INVALID_PARAMETER_VALUE, ex.code
      assert_equal 'service', ex.locator
    end

    test 'request handler throws exception if service is not specified' do
      ex = assert_raise CswRequestValidationException do
        CswRequestHandler.new(input :service => nil).handle
      end
      assert_equal MISSING_PARAMETER_VALUE, ex.code
      assert_equal 'service', ex.locator
    end

    test 'request handler throws exception if version is not specified' do
      ex = assert_raise CswRequestValidationException do
        CswRequestHandler.new(input :version => nil).handle
      end
      assert_equal MISSING_PARAMETER_VALUE, ex.code
      assert_equal 'version', ex.locator
    end

    test 'request handler throws exception if version is not specified property' do
      ex = assert_raise CswRequestValidationException do
        CswRequestHandler.new(input :version => "2.0.0").handle
      end
      assert_equal VERSION_NEGOTIATION_FAILED, ex.code
    end

    test 'request handler is not case sensitive' do
      assert_nothing_raised do
        CswRequestHandler.new(input :service => 'cSw').handle
        CswRequestHandler.new(input :service => 'CSW').handle
      end
    end

    private
    def input(override)
      {:service => 'CSW', :version => '2.0.2'}.merge(override)
    end
  end
end