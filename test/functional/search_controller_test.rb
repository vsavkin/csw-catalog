require 'test_helper'

class SearchControllerTest < ActionController::TestCase  
  def setup
    @db = Catalog::Test::MetadataDatabase.new
    @gateway = flexmock(:reinit => nil)
    @controller = SearchController.new(@gateway)
  end
  
  test 'clean page cleans session and shows search page' do
    get :clean_page
    assert_nil session[:extent]
    assert_redirected_to :controller => 'search', :action => 'index'
  end

  test 'saves extent to session' do
    post :save_extent, :crs => 'crs', :x1=>'1', :y1=>'1', :x2 => '2', :y2 => '2'
    assert_equal Envelope.parse('1 1 2 2 crs'), session[:extent]
  end

  test 'saves extent with invalid values prints error message and cleans session' do
    post :save_extent, :crs => 'crs', :x1=>'BOO', :y1=>'1', :x2 => '2', :y2 => '2'
    assert_not_nil assigns(:error_message)
    assert_nil session[:extent]
  end

  test 'if query is not specified result is empty' do
    post :index
    assert_equal assigns(:metadatas), []
  end

  test 'set empty list to metadatas if cant find any metadata' do
    filter = Catalog::Core::Filter.new(PropertyIsLike.new('AnyText', query = 'broom bram'))
    @gateway.should_receive(:find_all_by).with(filter).once.and_return([])
    post :index, :query => query
    assert_equal assigns(:metadatas), []
  end

  test 'test returns metadatas by full text' do
    md = @db.create_metadata_with(:title => 'my title')
    filter = Catalog::Core::Filter.new(PropertyIsLike.new('AnyText', query = 'my'))
    @gateway.should_receive(:find_all_by).with(filter).once.and_return([md])
    post :index, :query => query
    assert_equal assigns(:metadatas), [md]
  end

  test 'like filter for query and extent filter for extent' do
    e = Envelope.parse('1 1 2 2')
    full_text = PropertyIsLike.new('AnyText', query = 'AAA')
    bbox = BBOX.new('BoundingBox', e)
    filter = Catalog::Core::Filter.new(And.new(full_text, bbox))

    @gateway.should_receive(:find_all_by).with(filter).once.and_return([])
    session[:extent] = e
    post :index, :query => query
  end
end
