require 'rexml/document'

module Catalog
  module Test
    module XmlTestUtil
      def check_xml_equals(required, actual)
        a = required.gsub("\n", '').gsub(' ', '')
        b = actual.gsub("\n", '').gsub(' ', '')
        assert_equal a, b
      end

      def check_xml_equals_with_fake_root(required, actual)
        check_xml_equals "<r>#{required}</r>", "<r>#{actual}</r>"  
      end

      def check_xml_structure(xml, list_of_nodes)
        doc = REXML::Document.new(xml)
        current_nodes = [doc.root]
        list_of_nodes.each do |e|
          node = current_nodes.find {|n| n.local_name == e}
          if node
            current_nodes = node.children
          else
            fail("Invalid xml structure #{xml}")
          end
        end
      end

      def check_xpath(xml, expected_value, xpath, attribute = nil)
        doc = REXML::Document.new(xml)
        value = REXML::XPath.first(doc, xpath)

        fail "There is not element with xpath #{xpath}" if value.nil?

        if attribute.nil?
          value = value.text
        else
          value = value.attributes[attribute]
        end
        assert_equal expected_value, value
      end
    end
  end
end
