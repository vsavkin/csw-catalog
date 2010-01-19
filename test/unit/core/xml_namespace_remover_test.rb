require "test_helper"

module Catalog::Core
  class XmlNamespaceRemoverTest < ActiveSupport::TestCase
    include Catalog::Test::XmlTestUtil

    test 'removes namespaces from xml document' do
      xml = '<a xmlns:ns1="boom" xmlns="foom" boom:schemaLocation="hello"><groom:b>hello</groom:b></a>'
      processed = XmlNamespaceRemover.remove(xml)
      check_xml_equals '<a><b>hello</b></a>', processed
    end
  end
end