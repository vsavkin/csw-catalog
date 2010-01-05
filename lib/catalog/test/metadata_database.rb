module Catalog
  module Test
    class MetadataDatabase
      def create_metadata_with(params)
        xml = read_file('iso_template.xml')
        values(params).each do |k, v|
          replace = "[#{k.to_s}]"
          xml.gsub!(replace, v)
        end
        id = params[:id] ||= "id"
        Catalog::Core::ISOMetadata.new(id, xml)
      end

      private
      def read_file(filename)
        File.read(File.dirname(__FILE__) + '/' + filename)
      end

      def values(override)
        std = {:title => 'Title!', :id => 'id', :abstract => 'abstract'}
        std.merge override
      end
    end
  end
end