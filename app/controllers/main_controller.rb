class MainController < ApplicationController
  def index
    redirect_to :controller => 'search'
  end

  def set_locale
    session[:locale] = params[:locale]
    redirect_to :controller => "search"
  end
end