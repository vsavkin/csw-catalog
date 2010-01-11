require 'init_catalog'

class SearchController < ApplicationController
  def initialize(gateway = InMemoryMetadataGateway.new)
    data = Metadata.all.collect do |m|
      MetadataFactory.create(m.id, m.standard, m.xml)
    end     
    @gateway = gateway
    @gateway.reinit data
  end

  def index
    @metadatas = [] and return if !params[:query]

    @query = params[:query].strip
    @geo = session[:geo]
    begin
      filter = create_filter(@query, @geo)
      @metadatas = @gateway.find_all_by(filter)
    rescue Exception => e
      @error_message = e.message
      session[:extent] = nil
      @metadatas = []
    end
  end

  def clean_page
    session[:geo] = nil
    redirect_to :action => 'index'
  end

  def geo_form
    @geo = session[:geo]
    if params[:show] then
      @geo ||= Polygon.parse('1 59 19 59 1 40 19 40')
      render :partial => 'geo_form'
    else
      render :partial => 'geo'
    end
  end

  def clear_geo_form
    session[:extent] = nil
    params[:show] = false
    geo_form
  end

  def save_geo
    begin
      p1 = Point.new(float_param(:x1), float_param(:y1))
      p2 = Point.new(float_param(:x2), float_param(:y2))
      p3 = Point.new(float_param(:x3), float_param(:y3))
      p4 = Point.new(float_param(:x4), float_param(:y4))
      geo = Polygon.new(p1, p2, p3, p4)
      session[:geo] = geo
    rescue
      @error_message = t :invalid_extent_error_message
      session[:geo] = nil
    end
    geo_form
  end

  private
  def create_filter(query, extent)
    full_text = PropertyIsLike.new('AnyText', query)
    if extent
      bbox = BBOX.new('BoundingBox', @geo.envelope)
      Catalog::Core::Filter.create(And.new(full_text, bbox))
    else
      Catalog::Core::Filter.create(full_text)  
    end
  end

  def float_param(name)
    Float(params[name])
  end
end
