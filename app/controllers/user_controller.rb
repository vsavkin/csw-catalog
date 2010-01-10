class UserController < ApplicationController
  def register_user
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash[:notice] = t :user_registered, :name => @user.name
      session[:user_id] = @user.id
      redirect_to :controller => 'main'
    end
  end

  def show_login
  end

  def login
    @current_user = User.find_by_login_and_password(params[:login], params[:password])
    if @current_user
      session[:user_id] = @current_user.id
      if session[:return_to]
        redirect_to session[:return_to]
        session[:return_to] = nil
      else
        redirect_to :controller=> 'personal'
      end
    else
      flash[:error] = t :invalid_login_or_password
      redirect_to :action => 'show_login'
    end
  end

  def logout
    session[:user_id] = @current_user = nil
    redirect_to :controller=>'main'
  end

end
