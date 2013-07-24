require 'test_helper'

class UpdatesControllerTest < ActionController::TestCase
  test 'should return 422 if no conversation was provided' do
    since = messages(:Tenant1Conv1Message2).created_at
    get :index, :since => since
    assert_response 422
  end

  test 'should filter messages by conversation and timestamp and return all active agents' do
    since = messages(:Tenant1Conv1Message2).created_at
    conversation_id = messages(:Tenant1Conv1Message1).conversation_id
    get :index, :conversation => conversation_id, :since => since
    assert_response :success
    json = response_json

    # verify the conversation
    assert_equal json['conversation']['id'].to_s, conversation_id.to_s

    # verify the messages array
    messages = Message.where(:conversation_id => messages(:Tenant1Conv1Message1).conversation_id).where('created_at > ?', since)
    validate_response_body(messages, json['messages'])

    # verify the agents array
    agents = Agent.available
    assert_equal json['agents'].size, agents.size
    agents.each {|a|
      assert json['agents'].detect{|j| j['display_name'] == a['display_name'] }
    }
  end
end
