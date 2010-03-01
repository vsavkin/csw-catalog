require "nokogiri"

module Catalog::Core
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
      processor = ISOMetadataXmlProcessor.new(@xml)
      processor.field(name)
    end

    def merge(new_field_values)
      processor = ISOMetadataXmlProcessor.new(@xml)
      new_field_values.each do |k,v|
        processor.update_field(k,v)
      end
      new_xml = processor.xml
      id = new_field_values[:identifier] || @id
      ISOMetadata.new(id, new_xml)
    end
  end

  class ISOMetadataXmlProcessor
    def initialize(xml)
      @doc = Nokogiri::XML(xml)
      @namespaces = {'gmd' => 'http://www.isotc211.org/2005/gmd',
                     'gco' => 'http://www.isotc211.org/2005/gco'}
    end

    def update_field(name, value)
      case name.to_s.downcase
        when 'title' then
          update_using_xpath("//gmd:title/gco:CharacterString", value)
        when 'abstract' then
          update_using_xpath("//gmd:abstract/gco:CharacterString", value)
        when 'subject' then
          update_using_xpath("//gmd:subject/gco:CharacterString", value)
        when 'modified' then
          update_using_xpath("//gmd:dateStamp/gco:Date", value)
      end
    end

    def field(name)
      case name.downcase
        when 'title' then
          get_using_xpath("//gmd:title/gco:CharacterString")
        when 'abstract' then
          get_using_xpath("//gmd:abstract/gco:CharacterString")
        when 'subject' then
          get_using_xpath("//gmd:subject/gco:CharacterString")
        when 'modified' then
          DateTime.parse(get_using_xpath("//gmd:dateStamp/gco:Date"))
        when 'anytext' then
          agg_fields('title', 'abstract', 'subject')
        when 'boundingbox' then
          bbox = '//gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/'
          south = get_using_xpath(bbox + 'gmd:southBoundLatitude/gco:Decimal').to_f
          north = get_using_xpath(bbox + 'gmd:northBoundLatitude/gco:Decimal').to_f
          east = get_using_xpath(bbox + 'gmd:eastBoundLongitude/gco:Decimal').to_f
          west = get_using_xpath(bbox + 'gmd:westBoundLongitude/gco:Decimal').to_f
          Envelope.new(Point.new(west, south), Point.new(east, north))
      end
    end

    def xml
      @doc.to_s
    end

    private
    def agg_fields(*field_names)
      fields = field_names.collect {|name| field(name)}.find_all{|m| !m.nil?}
      fields.join(' ')
    end

    def get_using_xpath(xpath)
      element = @doc.xpath(xpath, @namespaces).first
      if element.nil?
        return nil
      else
        element.text
      end
    end

    def update_using_xpath(xpath, value)
      @doc.xpath(xpath, @namespaces).each do |e|
        e.content = value
      end
    end
  end
end