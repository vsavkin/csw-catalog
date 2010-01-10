require "test_helper"

module Catalog
  module Core
    class EnvelopeTest < ActiveSupport::TestCase

      test 'envelope can check bbox with other envelopes' do
        e = Envelope.new(Point.new(100,100), Point.new(200,200))
        bb1 = Envelope.new(Point.new(0,0), Point.new(200,200))
        bb2 = Envelope.new(Point.new(100,100), Point.new(200,150))

        assert bb1.bbox(e)
        assert ! bb2.bbox(e)
      end
    end
  end
end
