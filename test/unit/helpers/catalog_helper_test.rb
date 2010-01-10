require 'test_helper'

class CatalogHelperTest < ActionView::TestCase
  test 'pretty xml doesnt change non xml text' do
    assert_equal 'ping', pretty_xml('ping')
    assert_equal h('<a>boo'), pretty_xml('<a>boo')
  end

  test 'pretty xml outputs xml in a pretty way' do
    assert_equal "&lt;a&gt;\n  boo\n&lt;/a&gt;", pretty_xml('<a>boo</a>')
  end
end
