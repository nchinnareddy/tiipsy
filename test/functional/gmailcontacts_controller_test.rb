require 'test_helper'

class GmailcontactsControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get authorize" do
    get :authorize
    assert_response :success
  end

end
