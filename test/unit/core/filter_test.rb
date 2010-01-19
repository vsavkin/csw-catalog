require "test_helper"

module Catalog::Core
  class FilterTest < ActiveSupport::TestCase
    include Catalog::Test::XmlTestUtil

    def setup
      @db = Catalog::Test::MetadataDatabase.new
    end

    test 'can generate and parse simple filter expressions' do
      filter = Filter.create(PropertyIsEqualTo.new('name', 'hello'))

      xml = filter.to_xml
      check_xml_structure xml, ['Filter', 'PropertyIsEqualTo', 'PropertyName']
      check_xml_structure xml, ['Filter', 'PropertyIsEqualTo', 'Literal']

      parsed = Filter.parse(xml)
      check_filters filter, parsed
    end

    test 'can generate and parse logical operators' do
      Filter.init!
      a = PropertyIsEqualTo.new('name1', 'hello')
      b = PropertyIsEqualTo.new('name2', 'hello')
      c = PropertyIsEqualTo.new('name3', 'hello')
      expr = And.new(a, Or.new(b, Not.new(c)))
      filter = Filter.create(expr)

      xml = filter.to_xml
      check_xml_structure xml, ['Filter', 'And', 'PropertyIsEqualTo', 'PropertyName']
      check_xml_structure xml, ['Filter', 'And', 'Or', 'Not', 'PropertyIsEqualTo', 'PropertyName']

      parsed = Filter.parse(xml)
      check_filters filter, parsed
    end

    test 'filters can check whether metadata applies some criteria' do
      md1 = @db.create_metadata_with(:id => '1', :title => 'mytitle', :modified => DateTime.parse('2010-01-01'))
      md2 = @db.create_metadata_with(:id => '2', :title => 'mytitle2', :modified => DateTime.parse('2010-01-02'))

      filter = Filter.create(PropertyIsEqualTo.new('Title', 'mytitle'))
      assert filter.check(md1)
      assert ! filter.check(md2)

      filter = Filter.create(PropertyIsNotEqualTo.new('Title', 'mytitle'))
      assert ! filter.check(md1)
      assert filter.check(md2)

      filter = Filter.create(PropertyIsGreaterThan.new('Modified', DateTime.parse('2010-01-01')))
      assert ! filter.check(md1)
      assert filter.check(md2)

      filter = Filter.create(PropertyIsGreaterThanEqualTo.new('Modified', DateTime.parse('2010-01-01')))
      assert filter.check(md1)
      assert filter.check(md2)

      filter = Filter.create(PropertyIsLessThan.new('Modified', DateTime.parse('2010-01-02')))
      assert filter.check(md1)
      assert !filter.check(md2)

      filter = Filter.create(PropertyIsLessThanEqualTo.new('Modified', DateTime.parse('2010-01-02')))
      assert filter.check(md1)
      assert filter.check(md2)

      filter = Filter.create(PropertyIsLike.new('Title', 'tle2'))
      assert ! filter.check(md1)
      assert filter.check(md2)
    end

    test 'filter parses dates' do
      filter = Filter.create(PropertyIsGreaterThan.new('Modified', DateTime.parse('2010-01-01')))
      xml = filter.to_xml

      puts "parsing"
      parsed = Filter.parse(xml)

      assert parsed.exp.required_value.kind_of?(DateTime)
      check_filters filter, parsed
    end

    test 'can use logical expressions for complex checking' do
      md1 = @db.create_metadata_with(:id => '1', :title => 'mytitle')
      md2 = @db.create_metadata_with(:id => '2', :title => 'mytitle2')

      Filter.init!
      cond1 = PropertyIsEqualTo.new('Title', 'mytitle')
      cond2 = PropertyIsEqualTo.new('Title', 'mytitle2')
      cond3 = PropertyIsEqualTo.new('Identifier', '1')

      filter = Filter.create(And.new(cond1, cond3))
      assert filter.check(md1)
      assert ! filter.check(md2)

      filter = Filter.create(And.new(Not.new(cond1), Not.new(cond3)))
      assert ! filter.check(md1)
      assert filter.check(md2)

      filter = Filter.create(Or.new(cond1, cond2))
      assert filter.check(md1)
      assert filter.check(md2)
    end

    test 'can use bbox operation to geo checking' do
      md1 = @db.create_metadata_with(:id => '1', :extent => Envelope.parse('0 0 5 5'))
      md2 = @db.create_metadata_with(:id => '2', :extent => Envelope.parse('0 0 10 10'))

      filter = Filter.create(BBOX.new('BoundingBox', Envelope.parse('0 0 7 7')))
      assert filter.check(md1)
      assert !filter.check(md2)
    end

    private
    def check_filters(required, actual)
      assert_equal required.to_xml, actual.to_xml
    end
  end
end