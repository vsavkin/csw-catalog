class PersonalController < ApplicationController
  before_filter :login_required, :except => 'show_metadata'

  def initialize
    super
    @validator = IsoSchemaValidator.new
  end

  def index
    @metadatas = Metadata.find_all_by_user_id(@current_user, :order => 'updated_at DESC')
  end

  def upload_metadata
    if !params[:upload] || !params[:upload][:datafile] then
      @error_message = 'Error: You must choose a metadata file'
    else
      xml = params[:upload][:datafile].read
      add_to_current_user xml
    end
    redirect_to :action => 'index'
  end

  def restful_upload_metadata
    @current_user = User.find_by_login_and_password(params[:login], params[:password])
    if !@current_user
      render :text => 'Error: Invalid login/password pair' and return
    end
    xml = params[:xml]
    message = add_to_current_user xml
    render :text => message
  end

  def delete_selected
    selected_metadatas = @current_user.metadatas.find(params[:selected])
    selected_metadatas.each do |m|
      m.destroy
    end
    redirect_to :action => 'index'
  end

  def delete_all_from_current_user
    @current_user.metadatas.each do |m|
      m.destroy
    end
    redirect_to :action => 'index'
  end

  def show_metadata
    @format = params[:f]
    md = Metadata.find_by_id(params[:id])
    if ! md
      flash[:error] = "There is no metadata with id #{id}"
    else
      @metadata = MetadataFactory.create(md.id, md.standard, md.xml)
    end
  end

  def edit_metadata_field
    field_name = params[:editorId].to_sym
    field_value = params[:value].strip
    md = Metadata.find_by_id(params[:id])
    raise CatalogException, "There is no metadatas with id: #{params[:id]}" unless md

    new_md = MetadataFactory.create(md.id, md.standard, md.xml).merge(field_name => field_value)
    @validator.validate(new_md)
    md.update_attribute :xml, new_md.xml
    render :text => field_value
  rescue Exception => e
    render :text => e.message, :status => 500
  end

  private
  def add_to_current_user(xml)
    md = MetadataFactory.create('stub', 'iso19115', xml)
    @validator.validate(md)
    @current_user.metadatas(true).create(:standard => 'iso19115', :xml => xml,
                                         :short_description => md.field('title'))
  rescue Exception => e
    return flash[:error] = "Error: Invalid format of your metadata file: #{e.message}"
  end

end
