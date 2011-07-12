require 'test_helper'

class ContactControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get authorize" do
    get :authorize
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get mail" do
    get :mail
    assert_response :success
  end

end
