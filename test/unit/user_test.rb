require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def test_invalid_with_empty_attributes
		user = User.new
		assert !user.valid?
		assert user.errors.invalid?(:name)
		assert user.errors.invalid?(:login)
		assert user.errors.invalid?(:password)
		assert user.errors.invalid?(:email)
	end

	def test_valid_with_fill_attributes
		user = User.new(:login => 'simon', :password => '12345', :name => 'name', :email => 'a@a.com')
		assert user.valid?
	end
end
