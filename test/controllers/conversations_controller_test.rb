require 'test_helper'

class ConversationsControllerTest < ActionController::TestCase
  test "should create a valid conversation" do
    post :create, :conversation => {:tenant_id => tenants(:Tenant1).id, :customer_id => customers(:Customer1).id, :active => true, :referer_url => "http:"}
    assert_response :success
  end

  test "should update a valid conversation" do
    put :update, :id => conversations(:Tenant1Conversation1).id, :conversation => {:active => false}
    assert_response :success
  end

  test "should get a valid conversation" do
    get :show, :id => conversations(:Tenant1Conversation1).id
    assert_response :success
  end

  test "should not get a nonexistent conversation" do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, :id => 999
    end
  end

  test "should get all conversations" do
    get :index
    assert_response :success
  end

end
