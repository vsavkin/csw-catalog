module Catalog
  module Core
    class InMemoryMetadataGateway
      def initialize(data = [])
        @data = data
      end

      def add(md)
        @data << md
      end

      def reinit(data)
        @data = data  
      end

      def size
        @data.size
      end

      def find_by_id(id)
        @data.find {|md| md.id == id}
      end

      def find_all_by(filter)
        @data.find_all{|md| filter.check(md)}
      end

      def all
        @data
      end
    end
  end
end