require 'test_helper'

class UserControllerTest < ActionController::TestCase
	test 'show register form' do
		get :register_user
		assert_response :success
		assert_template 'register_user'
	end

	test 'show create user log in and redirect to main' do
		post :register_user, :user=> {:login => 'simon', :password => '12345',
			:name => 'name', :email => 'a@a.com'}
	  	assert_not_nil session[:user_id]
	  	assert_redirected_to :controller => 'main'
	end

	test 'show register page with error message if data is invalid' do
		post :register_user, :user => {:login => '', :password => '', :name => '', :email => ''}
		assert_response :success
		assert_template 'register_user'
	  	assert_nil session[:user_id]
    end

    test 'show login form' do
		get :login
		assert_response :success
		assert_template 'show_login'
	end

	test 'perform user login' do
		post :login, :login => 'john', :password => '123'
		assert_redirected_to :controller => 'personal', :action => 'index'
		assert_equal users(:john).id, session[:user_id]
		assert_equal users(:john), assigns(:current_user)
	end

	test 'fail user login' do
	  	post :login, :login => 'no such', :password => 'user'
	  	assert_response :success
	  	assert_template 'show_login'
	  	assert_nil session[:user_id]
	end

	test 'redirect after login with return url' do
	  	post :login, { :login => 'john', :password => '123' },
	      :return_to => '/path'
	  	assert_redirected_to '/path'
	end

	test 'logout and clear session' do
	  	post :login, :login => 'john', :password => '123'
	  	assert_not_nil assigns(:current_user)
	 	assert_not_nil session[:user_id]

	  	delete :logout
	  	assert_redirected_to :controller => 'main'
	  	assert_nil assigns(:current_user)
	  	assert_nil session[:user_id]
	end
end
