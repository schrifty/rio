require 'test_helper'

class ConversationsControllerTest < ActionController::TestCase
  test "should post create" do
    post :create, :conversation => {:tenant_id => 1, :active => true, :customer_id => 1, :referer_url => "http:"}
    assert_response :success
  end

  test "should put update" do
    put :update, :id => 1, :conversation => {:active => false}
    assert_response :success
  end

  test "should get a conversation" do
    get :show, :id => 1
    assert_response :success
  end

  test "should not find a nonexistent conversation" do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, :id => 999
    end
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
