require 'test_helper'

class PersonalControllerTest < ActionController::TestCase
  def setup
    session[:user_id] = users(:john).id
    @db = Catalog::Test::MetadataDatabase.new
  end

  test 'write error message if upload file is not selected' do
    post :upload_metadata
    assert_not_nil assigns(:error_message)
    assert users(:john).metadatas.empty?
  end

  test 'add metadata to user if upload file is selected' do
    file = flexmock(:read => @db.create_metadata_with(:id => 1).xml)
    post :upload_metadata, :upload => {:datafile => file}
    assert_equal users(:john).metadatas.size, 1
    assert_nil flash[:error]
  end

  test 'delete selected metadatas' do
    john = users(:john)
    md1 = add_metadata_to_user(john)
    md2 = add_metadata_to_user(john)
    md3 = add_metadata_to_user(john)

    post :delete_selected, :selected => [md1.id, md3.id]
    assert_equal john.metadatas(true).size, 1
    assert_equal john.metadatas[0].id, md2.id
  end

  test 'upload metadata restful way' do
    john = users(:john)
    xml = @db.create_metadata_with(:id => 1).xml
    post :restful_upload_metadata,
         :login => john.login, :password => john.password, :xml => xml
    assert_equal john.metadatas(true).size, 1
    assert ! /^Error/.match(@response.body)
  end

  test 'return error message if user password pair is invalid' do
    post :restful_upload_metadata,
         :login => 'bad', :password => 'bad', :xml => 'some xml'
    assert /^Error/.match(@response.body)
  end

  test 'return metadata in xml format' do
    md = add_metadata_to_user(users(:john))
    get :show_metadata, :f => 'xml', :id => md.id
    assert_equal 'xml', assigns(:format)
    assert_template 'show_metadata'
  end

  test 'return metadata in nice format' do
    md = add_metadata_to_user(users(:john))
    get :show_metadata, :f => 'nice', :id => md.id
    assert_equal 'nice', assigns(:format)
    assert_template 'show_metadata'
  end

  test 'show error message if there_is no such metadata' do
    get :show_metadata, :f => 'nice', :id => "BOO"
    assert_template 'show_metadata'
    assert_not_nil flash[:error]
  end

  private
  def add_metadata_to_user(user)
    xml = @db.create_metadata_with(:id => 1).xml
    user.metadatas(true).create(:format => "iso19115", :xml => xml)
  end
end
