module Catalog
  module Core
    class XmlNamespaceRemover
      def self.remove(xml)
        xml.gsub(/<\w+:/, '<').
                gsub(/<\/\w+:/, '</').
                gsub(/xmlns:[\w]+="[^"]+"/, '').
                gsub(/xmlns="[^"]+"/, '').
                gsub(/\w+:schemaLocation="[^"]+"/, '')
      end
    end
  end
end