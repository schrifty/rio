require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  test "should post create" do
    post :create, :message => {:tenant_id => 1, :conversation_id => 1, :agent_id => 1, :sent_by => "twitter",
                               :text => "This is the message"}
    assert_response :success
  end

  test "should get a message" do
    get :show, :id => 1
    assert_response :success
  end

  test "should not find a nonexistent message" do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, :id => 999
    end
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
