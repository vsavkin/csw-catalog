class CatalogController < ApplicationController
  def index
    @additional_keys = ['', '', '']
    @additional_values = ['', '', '']
    @request = 'GetCapabilities'
    @service = 'csw'
    @version = '2.0.2'
  end

  def send_request
    @request = params[:request]
    @service = params[:service]
    @version = params[:version]
    @additional_keys = params[:additional_keys].collect{|v| v.strip}
    @additional_values = params[:additional_values].collect{|v| v.strip}

    args = {:request => @request, :service => @service, :version => @version}
    @additional_keys.each_with_index do |e,i|
      args[e] = @additional_values[i] unless e.empty?
    end

    @handler_manager = Catalog::Service::HandlerManager.new
    @response = @handler_manager.process(args)
    render :action => 'index'
  end
end
