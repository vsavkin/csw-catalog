require 'test_helper'

class CswControllerTest < ActionController::TestCase

  def setup
    @controller = CswController.new
  end

  test 'returns exception if request is invalid' do
    get :endpoint, :request => 'invalid'
    assert_match /is not supported/, @response.body    
  end

  test 'returns exception if version or service is invalid' do
    get :endpoint, :request => 'getcapabilities', :service => 'BOOM'
    assert_match /Service must be/, @response.body
  end
end
