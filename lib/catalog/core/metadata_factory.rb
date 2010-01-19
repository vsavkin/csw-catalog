module Catalog::Core
  class MetadataFactory
    def self.create(id, format, xml)
      ISOMetadata.new(id, xml)
    end
  end
end