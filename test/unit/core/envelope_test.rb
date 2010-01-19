require "test_helper"

module Catalog::Core
  class EnvelopeTest < ActiveSupport::TestCase

    test 'envelope can check bbox with other envelopes' do
      e = Envelope.new(Point.new(100, 100), Point.new(200, 200))
      bb1 = Envelope.new(Point.new(0, 0), Point.new(200, 200))
      bb2 = Envelope.new(Point.new(100, 100), Point.new(200, 150))

      assert bb1.bbox(e)
      assert ! bb2.bbox(e)
    end

    test 'polygon can return envelope including it' do
      p = Polygon.new(Point.new(-100, -100), Point.new(0, 100), Point.new(100, 0))
      assert_equal Envelope.parse('-100 -100 100 100'), p.envelope
    end

  end
end
