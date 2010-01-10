module Catalog
  module Core
    class Envelope
      attr_reader :lower_corner, :upper_corner, :crs

      def initialize(lower, upper, crs = 'crs86')
        @lower_corner = lower
        @upper_corner = upper
        @crs = crs
      end

      def self.parse(str)
        p = str.split(' ')
        lower = Point.new(p[0].to_f, p[1].to_f)
        upper = Point.new(p[2].to_f, p[3].to_f)
        system = p.size == 5 ? p[4] : 'crs86'
        Envelope.new(lower, upper, system)
      end

      def bbox(envelope)
        @lower_corner <= envelope.lower_corner &&
                @upper_corner >= envelope.upper_corner
      end

      def ==(envelope)
        return false unless envelope.kind_of?(Envelope)
        @lower_corner == envelope.lower_corner &&
        @upper_corner == envelope.upper_corner &&
        @crs == envelope.crs           
      end

      def to_s
        "#{@lower_corner}-#{@upper_corner} in #{@crs}"
      end
    end

    class Point
      attr_reader :x, :y

      def initialize(x,y)
        @x, @y = x, y
      end

      def <=(point)
        @x <= point.x && @y <= point.y
      end

      def >=(point)
        x >= point.x && y >= point.y   
      end

      def ==(point)
        x == point.x && y == point.y
      end

      def to_s
        "(#{@x},#{@y})"
      end
    end
  end
end