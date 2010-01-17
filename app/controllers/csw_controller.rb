class CswController < ApplicationController

  def initialize
    gateway = Catalog::Core::InMemoryMetadataGateway.new(all_metadata)
    @handler_manager = Catalog::Service::HandlerManager.new(gateway)
  end

  def endpoint
    xml = @handler_manager.process(params)
    render :xml => xml
  end
end
