module Catalog
  module Core
    class MetadataFactory
      def self.create(id, format, xml)
        ISOMetadata.new(id, xml)
      end
    end
  end
end