require 'test_helper'

class InvitesControllerTest < ActionController::TestCase
  test 'should post create' do
    post :create, :invite => {:tenant_id => tenants(:Tenant1).id, :recipient_email => "jdoe@gmail.com"}
    assert_response :success
  end

  test 'should delete a valid invite' do
    get :destroy, :id => invites(:Invite1).id
    assert_response :success
  end

  test 'should get a valid invite' do
    get :show, :id => invites(:Invite1).id
    assert_response :success
  end

  test 'should not get a nonexistent invite' do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, :id => 999
    end
  end

  test 'should get all invites' do
    get :index
    assert_response :success
  end

end
