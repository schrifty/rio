require 'test_helper'

class TenantsControllerTest < ActionController::TestCase
  test "should post create" do
    post :create, :tenant => {:twitter_id => "marc", :email => "marc@gmail.com"}
    assert_response :success
  end

  test "should not allow deletes" do
    assert_raises(ActionController::UrlGenerationError) do
      delete :destroy, :id => 1
    end
  end

  test "should get update" do
    put :update, :id => 1, :tenant => {:twitter_id => "peter", :email => "peter@gmail.com"}
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get a tenant" do
    get :show, :id => 1
    assert_response :success
  end

  test "should not get a nonexistent tenant" do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, :id => 999
    end
  end


end
