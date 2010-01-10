require "rexml/document"

module Catalog
  module Core
    class ISOMetadata
      attr_reader :xml, :id

      def initialize(id, xml)
        @xml = xml
        @id = id        
      end

      def to_dublin_core
        dc_data = {}
        dc_data[:identifier] = field('identifier')
        dc_data[:title] = field('title')
        dc_data[:description] = field('abstract')
        dc_data[:modified] = field('modified')
        DCMetadata.new(dc_data)
      end

      def field(name)
        return @id if name.downcase == 'identifier'
        parser = ISOMetadataXmlParser.new(@xml)
        parser.field(name)
      end
    end

    class ISOMetadataXmlParser
      def initialize(xml)
        xml_without_namespaces = XmlNamespaceRemover.remove(xml)
        @doc = REXML::Document.new(xml_without_namespaces)
      end

      def field(name)
        case name.downcase
          when 'title'    then get_using_xpath("//title/CharacterString")
          when 'abstract' then get_using_xpath("//abstract/CharacterString") 
          when 'subject'  then get_using_xpath("//subject/CharacterString")
          when 'modified' then DateTime.parse(get_using_xpath("//dateStamp/Date"))
          when 'anytext'  then agg_fields('title', 'abstract', 'subject')
          when 'boundingbox' then nil            
        end
      end

      private
      def agg_fields(*field_names)
        fields = field_names.collect {|name| field(name)}.find_all{|m| !m.nil?}
        fields.join(' ')        
      end

      def get_using_xpath(xpath)
        element = REXML::XPath.first(@doc, xpath)
        if element.nil?
          return nil
        else
          element.text
        end
      end
    end
  end
end