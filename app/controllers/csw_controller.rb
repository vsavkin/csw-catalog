class CswController < ApplicationController
  include Catalog::Service

  def initialize()
    @handlers = {:getcapabilities => Catalog::Service::GetCapabilitiesHandler}
  end

  def endpoint
    request = params[:request]
    raise 'Request parameter must be specified' if request.nil?

    handler_type = @handlers[request.to_sym]
    raise "Request type '#{request}' is not supported" if handler_type.nil?

    handler_type.new(params).handle
  rescue Exception => e
    render :text => e.message
  end
end
