require "test_helper"

module Catalog::Service
  class XmlExceptionFormatterTest < ActiveSupport::TestCase
    include Catalog::Test::XmlTestUtil

    def setup
      @formatter = XmlExceptionFormatter.new
    end

    test 'generates xml with exception code and text using exception object' do
      exception = CswRequestValidationException.new('test', MISSING_PARAMETER_VALUE, 'loc')
      xml = @formatter.format(exception)

      check_xml_structure xml, ['ExceptionReport', 'Exception', "ExceptionText"]
      check_xpath xml, MISSING_PARAMETER_VALUE, '//Exception', 'exceptionCode'
      check_xpath xml, 'loc', '//Exception', 'locator'
      check_xpath xml, 'test', '//ExceptionText'
    end
  end
end