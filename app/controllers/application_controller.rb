# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'init_catalog'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :logged_in?
  before_filter :fetch_logged_in_user, :set_locale

  protected

  def fetch_logged_in_user
		puts 'i am here'
    return unless session[:user_id]
    @current_user = User.find_by_id(session[:user_id])
  end

  def logged_in?
    ! @current_user.nil?
  end

  def login_required
    return true if logged_in?
    session[:return_to] = request.request_uri
    redirect_to(:controller => 'user', :action => 'show_login') and return false
  end

  def root_required
    if logged_in? && @current_user.login == ENV['root']
      return true
    else
      flash[:error] = 'Error: Only root user can access these pages'
      redirect_to(:controller => 'main', :action => 'index')
    end
  end

  def set_locale
    I18n.locale = session[:locale] unless session[:locale].blank?
    true
  end

  def all_metadata
    Metadata.all.collect do |m|
      MetadataFactory.create(m.id, m.standard, m.xml)
    end
  end
end
