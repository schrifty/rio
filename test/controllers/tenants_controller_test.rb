require 'test_helper'

class TenantsControllerTest < ActionController::TestCase
  test "should post create" do
    post :create, :tenant => {:twitter_id => "marc", :email => "marc@gmail.com"}
    assert_response :success
  end

  test "should not allow deletes" do
    assert_raises(ActionController::UrlGenerationError) do
      delete :destroy, :id => tenants(:Tenant1).id
    end
  end

  test "should get update" do
    put :update, :id => tenants(:Tenant1).id, :tenant => {:twitter_id => "peter", :email => "peter@gmail.com"}
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get a tenant" do
    get :show, :id => tenants(:Tenant1).id
    assert_response :success
  end

  test "should not get a nonexistent tenant" do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, :id => 999
    end
  end


end
