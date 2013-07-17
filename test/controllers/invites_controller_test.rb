require 'test_helper'

class InvitesControllerTest < ActionController::TestCase
  test "should post create" do
    post :create, :invite => {:tenant_id => 1, :recipient_email => "jdoe@gmail.com"}
    assert_response :success
  end

  test "should delete destroy" do
    get :destroy, :id => 1
    assert_response :success
  end

  test "should get an invite" do
    get :show, :id => 1
    assert_response :success
  end

  test "should not find a nonexistent invite" do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, :id => 999
    end
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
