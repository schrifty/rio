require 'test_helper'

class AgentsControllerTest < ActionController::TestCase
  test "should get create" do
    post :create, :agent => {:tenant_id => 1, :available => true, :engaged => true, :display_name => "Johnny Doe",
                             :encrypted_password => "blech", :xid => "abc", :admin => true, :crap => true}
    assert_response :success
  end

  test "should get update" do
    put :update, :id => 1, :agent => {:display_name => "Jane Doe"}
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get an agent" do
    get :show, :id => 1
    assert_response :success
  end

  test "should not find a nonexistent agent" do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, :id => 999
    end
  end
end
