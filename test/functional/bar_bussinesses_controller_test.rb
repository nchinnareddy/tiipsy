require 'test_helper'

class BarBussinessesControllerTest < ActionController::TestCase
  setup do
    @bar_bussiness = bar_bussinesses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bar_bussinesses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bar_bussiness" do
    assert_difference('BarBussiness.count') do
      post :create, :bar_bussiness => @bar_bussiness.attributes
    end

    assert_redirected_to bar_bussiness_path(assigns(:bar_bussiness))
  end

  test "should show bar_bussiness" do
    get :show, :id => @bar_bussiness.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @bar_bussiness.to_param
    assert_response :success
  end

  test "should update bar_bussiness" do
    put :update, :id => @bar_bussiness.to_param, :bar_bussiness => @bar_bussiness.attributes
    assert_redirected_to bar_bussiness_path(assigns(:bar_bussiness))
  end

  test "should destroy bar_bussiness" do
    assert_difference('BarBussiness.count', -1) do
      delete :destroy, :id => @bar_bussiness.to_param
    end

    assert_redirected_to bar_bussinesses_path
  end
end
