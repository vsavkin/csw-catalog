require "rexml/document"

module Catalog
  module Core
    class ISOMetadata
      attr_reader :xml

      def initialize(id, xml)
        @xml = xml
        @id = id
      end

      def to_dublin_core
        parser = ISOMetadataXmlParser.new(@xml)
        dc_data = {}
        dc_data[:identifier] = @id
        dc_data[:title] = parser.title
        dc_data[:description] = parser.description
        dc_data[:modified] = parser.modified
        DCMetadata.new(dc_data)
      end
    end

    class ISOMetadataXmlParser
      def initialize(xml)
        xml_without_namespaces = XmlNamespaceRemover.remove(xml)
        @doc = REXML::Document.new(xml_without_namespaces)
      end

      def title
        get_using_xpath("//title/CharacterString")
      end

      def description
        get_using_xpath("//abstract/CharacterString")
      end

      def subject
        get_using_xpath("//subject/CharacterString")
      end

      def modified
         get_using_xpath("//dateStamp/Date")
      end

      private
      def get_using_xpath(xpath)
        element = REXML::XPath.first(@doc, "//title/CharacterString")
        if element.nil?
          return nil
        else
          element.text
        end
      end
    end
  end
end