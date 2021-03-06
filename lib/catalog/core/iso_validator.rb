module Catalog::Core
  class IsoSchemaValidator
    def initialize
      path = "#{File.dirname(__FILE__)}/../schemas/iso/composite.xsd"      
      schema_doc = LibXML::XML::Document.file(path)
      @schema = LibXML::XML::Schema.document(schema_doc)
    end

    def validate(metadata)
      document = LibXML::XML::Document.string(metadata.xml)
      begin
        document.validate_schema(@schema)
      rescue Exception => e
        raise CatalogException.new(e.message)
      end
    end
  end

  class IsoSemanticValidator
    def validate(xml)

    end
  end

  class IsoValidator
    def initialize
      @schema = IsoSchemaValidator.new
      @semantic = IsoSemanticValidator.new
    end

    def validate(xml)
      @schema.validate(xml)
      @semantic.validate(xml)
    end
  end
end
