require 'rexml/document'

module Catalog::Test
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
          fail("Invalid xml structure #{xml}, #{list_of_nodes.join(' / ')}")
        end
      end
    end

    def check_xpath(xml, expected_value, xpath, attribute = nil)
      doc = REXML::Document.new(xml)
      node = REXML::XPath.first(doc, xpath)
      fail "There is not element with xpath #{xpath}" if node.nil?

      if attribute.nil?
        value = node.text
      else
        value = node.attributes[attribute]
      end
      fail("#{expected_value} != #{value}") if expected_value != value
    end

    def check_xml(xml, &block)
      fail("Xml must be string") unless xml.kind_of?(String)
      builder = XmlTestUtilBuilder.new(xml)
      builder.instance_eval &block
    end
  end

  class XmlTestUtilBuilder
    include XmlTestUtil

    def initialize(xml)
      @xml = xml
    end

    def structure(*list_of_nodes)
      check_xml_structure @xml, list_of_nodes
    end

    def xpath(value, xpath, attribute = nil)
      check_xpath @xml, value, xpath, attribute
    end
  end
end
