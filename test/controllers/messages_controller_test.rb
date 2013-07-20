require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  test 'should create a message and return it' do
    post :create, :message => {:tenant_id => tenants(:Tenant1).id, :conversation_id => conversations(:Tenant1Conversation1).id, :agent_id => agents(:Agent1).id, :sent_by => 'twitter',
                               :text => 'This is the message'}
    assert_response :success
    messages = Message.where(:text => 'This is the message')
    validate_response_body(messages, response_json)
  end

  test 'should create a message and return all messages since the last update' do
    since = messages(:Tenant1Conv1Message2).created_at
    post :create, :message => {:tenant_id => tenants(:Tenant1).id, :conversation_id => conversations(:Tenant1Conversation1).id, :agent_id => agents(:Agent1).id, :sent_by => 'twitter',
                               :text => 'Yet another message', :since => since}
    assert_response :success
    messages = Message.where(:conversation_id => messages(:Tenant1Conv1Message1).conversation_id).where('created_at > ?', since)
    validate_response_body(messages, response_json)
  end

  test 'should create the message AND the conversation when we have no conversation id, and return the message with the new conversation id' do
    post :create, :message => {:tenant_id => tenants(:Tenant1).id, :agent_id => agents(:Agent1).id, :sent_by => 'twitter',
                               :text => 'This is the message', :display_name => 'Peter Jackson'}
    assert_response :success
    messages = Message.where(:text => 'This is the message')
    validate_response_body(messages, response_json)
    assert messages.first.conversation
    assert_equal messages.first.conversation.customer.display_name, 'Peter Jackson'
  end

  test 'should create the message AND the conversation when we have an empty conversation id, and return the message with the new conversation id' do
    post :create, :message => {:tenant_id => tenants(:Tenant1).id, :agent_id => agents(:Agent1).id, :sent_by => 'twitter',
                               :conversation_id => '', :text => 'This is the message', :display_name => 'Peter Jackson'}
    assert_response :success
    messages = Message.where(:text => 'This is the message')
    validate_response_body(messages, response_json)
    assert messages.first.conversation
    assert_equal messages.first.conversation.customer.display_name, 'Peter Jackson'
  end

  test 'should get a message' do
    get :show, :id => messages(:Tenant1Conv1Message1).id
    assert_response :success
    assert response_json
  end

  test 'should not find a nonexistent message' do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, :id => 999
    end
  end

  test 'should filter messages by tenant and timestamp' do
    since = messages(:Tenant1Conv1Message2).created_at
    get :index, :tenant => messages(:Tenant1Conv1Message1).tenant_id, :since => since
    assert_response :success

    # make sure that all messages you'd expect to be returned (and only those messages) have been returned
    messages = Message.where(:tenant_id => messages(:Tenant1Conv1Message1).tenant_id).where('created_at > ?', since)
    validate_response_body(messages, response_json)
  end

  test 'should filter messages by conversation' do
    since = messages(:Tenant1Conv1Message2).created_at
    get :index, :conversation => messages(:Tenant1Conv1Message1).conversation_id
    assert_response :success

    # make sure that all messages you'd expect to be returned (and only those messages) have been returned
    messages = Message.where(:conversation_id => messages(:Tenant1Conv1Message1).conversation_id)
    validate_response_body(messages, response_json)
  end

  test 'should filter messages by conversation and timestamp' do
    since = messages(:Tenant1Conv1Message2).created_at
    get :index, :conversation => messages(:Tenant1Conv1Message1).conversation_id, :since => since
    assert_response :success

    # make sure that all messages you'd expect to be returned (and only those messages) have been returned
    messages = Message.where(:conversation_id => messages(:Tenant1Conv1Message1).conversation_id).where('created_at > ?', since)
    validate_response_body(messages, response_json)
  end

end
