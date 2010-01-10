class CswController < ApplicationController

  def initialize
    @handler_manager = Catalog::Service::HandlerManager.new
  end

  def endpoint
    xml = @handler_manager.process(params)
    render :xml => xml
  end
end
