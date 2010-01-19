module Catalog::Core
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

    def west
      @lower_corner.x
    end

    def east
      @upper_corner.x
    end

    def north
      @upper_corner.y
    end

    def south
      @lower_corner.y
    end

    def to_s
      "#{@lower_corner}-#{@upper_corner} in #{@crs}"
    end
  end

  class Polygon
    attr_reader :points

    def initialize(*points)
      @points = points
    end

    def self.parse(str)
      p = str.split(' ')
      points = []
      i = 0
      while i < p.size
        points << Point.new(p[i].to_f, p[i + 1].to_f)
        i += 2
      end
      Polygon.new(*points)
    end

    def envelope
      min_x, min_y = 1000000, 1000000
      max_x, max_y = -1000000, -1000000
      for p in points
        min_x = p.x < min_x ? p.x : min_x
        min_y = p.x < min_y ? p.y : min_y
        max_x = p.x > max_x ? p.x : max_x
        max_y = p.y > max_y ? p.y : max_y
      end
      Envelope.new(Point.new(min_x, min_y), Point.new(max_x, max_y))
    end

    def to_s
      @points.collect{|m| m.to_s}.join(',')
    end

    def [](index)
      @points[index]
    end

    def ==(polygon)
      return false unless polygon.kind_of?(Polygon)
      @points == polygon.points
    end
  end

  class Point
    attr_reader :x, :y

    def initialize(x, y)
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