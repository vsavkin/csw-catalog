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
    @extent = session[:extent]
    begin
      filter = create_filter(@query, @extent)
      @metadatas = @gateway.find_all_by(filter)
    rescue Exception => e
      @error_message = e.message
      session[:extent] = nil
      @metadatas = []
    end
  end

  def clean_page
    session[:extent] = nil
    redirect_to :action => 'index'
  end

  def extent_form
    @extent = session[:extent]
    if params[:show] then
      @extent ||= Envelope.parse('0 0 10 10')
      render :partial => 'extent_form'
    else
      render :partial => 'extent'
    end
  end

  def clear_extent_form
    session[:extent] = nil
    params[:show] = false
    extent_form
  end

  def save_extent
    begin
      crs = params[:crs]
      env = Envelope.new(Point.new(float_param(:x1), float_param(:y1)),
                         Point.new(float_param(:x2), float_param(:y2)),
                         crs)
      session[:extent] = env
    rescue
      @error_message = t :invalid_extent_error_message
      session[:extent] = nil
    end
    extent_form
  end

  private
  def create_filter(query, extent)
    full_text = PropertyIsLike.new('AnyText', query)
    if extent
      bbox = BBOX.new('BoundingBox', @extent)
      Catalog::Core::Filter.create(And.new(full_text, bbox))
    else
      Catalog::Core::Filter.create(full_text)  
    end
  end

  def float_param(name)
    Float(params[name])
  end
end
