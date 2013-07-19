require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  test "should get create" do
    get :create, :customer => {:tenant_id => tenants(:Tenant1).id, :display_name => "Customer X"}
    assert_response :success
  end

  test "should update a valid customer" do
    get :update, :id => customers(:Customer1).id, :customer => {:display_name => "Customer Y"}
    assert_response :success
  end

  test "should get a valid customer" do
    get :show, :id => customers(:Customer1).id
    assert_response :success
  end

  test "should not get a nonexistent customer" do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, :id => 999
    end
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
