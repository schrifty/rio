require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  test "should get create" do
    get :create, :customer => {:tenant_id => 1, :display_name => "Customer X"}
    assert_response :success
  end

  test "should get update" do
    get :update, :id => 1, :customer => {:display_name => "Customer Y"}
    assert_response :success
  end

  test "should get a customer" do
    get :show, :id => 1
    assert_response :success
  end

  test "should not find a nonexistent customer" do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, :id => 999
    end
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
