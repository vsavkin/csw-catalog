module Catalog
  module Core
    class DCMetadata
      def initialize(data)
        validate(data)
        @data = data
      end

      def brief
        to_xml 'BriefRecord', ['identifier', 'title', 'type', 'BoundingBox']
      end

      def summary
        to_xml 'SummaryRecord', ['identifier', 'title', 'type', 'format', 'relation',
                                 'modified', 'abstract', 'spatial', 'BoundingBox']
      end

      def full
        to_xml 'Record', ['identifier', 'title', 'type', 'format', 'relation',
                                 'modified', 'abstract', 'spatial', 'BoundingBox']
      end

      def [](property_name)
        @data[property_name]  
      end

      private
      def validate(data)
        if !data[:title] || !data[:identifier]
          raise CatalogException, 'Dublin Core metadata must have title and identifier' 
        end
      end

      def to_xml(root_element, elements)
        b = Builder::XmlMarkup.new
        root_args = {'xmlns' => 'http://www.opengis.net/cat/csw/2.0.2',
                     'xmlns:dc' => 'http://purl.org/dc/elements/1.1/',
                     'xmlns:dct' => 'http://purl.org/dc/terms/',
                     'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                     'xsi:schemaLocation' => 'http://www.opengis.net/cat/csw/2.0.2 csw.xsd'}

        b.tag!(root_element, root_args) do
          for e in elements
            sym = e.to_sym
            b.dc sym, @data[sym] if @data.has_key?(sym)
          end
        end
      end
    end
  end
end