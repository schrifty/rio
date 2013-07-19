require 'test_helper'

class AgentsControllerTest < ActionController::TestCase
  test 'should get create' do
    post :create, :agent => {:tenant_id => tenants(:Tenant1).id, :available => true, :engaged => true, :display_name => "Johnny Doe",
                             :encrypted_password => "blech", :xid => "abc", :admin => true, :crap => true}
    assert_response :success
  end

  test 'should update an agent' do
    put :update, :id => agents(:Agent1).id, :agent => {:display_name => "Jane Doe"}
    assert_response :success
  end

  test 'should get all agents' do
    get :index
    assert_response :success
  end

  test 'should get a single agent' do
    get :show, :id => agents(:Agent1).id
    assert_response :success
  end

  test 'should not find a nonexistent agent' do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, :id => 999
    end
  end
end
