require 'spec_helper'

describe UpdatesController do
  before do
    @tenant1 = create(:tenant)
    @tenant2 = create(:tenant)
    @agent1 = create(:agent, available: 1)
    @agent2 = create(:agent, available: 1)
    @agent3 = create(:agent, available: 1)
    @conversation1 = create(:conversation, tenant: @tenant1)
    @conversation2 = create(:conversation, tenant: @tenant2)
    @message1 = create(:message, tenant: @tenant1, conversation: @conversation1, created_at: '2013-07-25 14:00:00', agent: nil)
    @message2 = create(:message, tenant: @tenant1, conversation: @conversation1, created_at: '2013-07-25 14:01:00', agent: @agent1)
    @message3 = create(:message, tenant: @tenant1, conversation: @conversation1, created_at: '2013-07-25 15:00:00', agent: nil)
    @message4 = create(:message, tenant: @tenant1, conversation: @conversation1, created_at: '2013-07-25 15:00:00', agent: @agent1)
    @message5 = create(:message, tenant: @tenant2, conversation: @conversation2, created_at: '2013-07-25 14:30:00', agent: nil)
  end

  it 'should return a 422 if no conversation was provided' do
    get :index, :since => @message1.updated_at
    response.status.should == 422
  end

  # this should be an integration test
  it 'should filter messages by conversation and timestamp and return all data needed by the client' do
    since = @message1.created_at
    conversation_id = @message1.conversation_id
    get :index, :conversation => conversation_id, :since => since
    expect(response.status).to eq(200)
    json = response_json

    # verify the conversation
    json['conversation']['id'].to_s.should == conversation_id.to_s

    # verify the messages array
    messages = Message.where(:conversation_id =>conversation_id).where('created_at > ?', since)
    validate_response_body(messages, json['messages'])

    # verify the agents array
    agents = Agent.by_tenant(@tenant1).available
    json['agents'].size.should == agents.size
    agents.each {|a|
      assert json['agents'].detect{|j| j['display_name'] == a['display_name'] }
    }
  end
end