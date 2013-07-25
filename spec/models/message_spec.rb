require 'spec_helper'

describe Message do
  context 'creation' do
    let(:message) { create(:message) }

    it 'should be valid' do
      message.should be_valid
    end

    it 'should not be valid without a tenant' do
      message.tenant = nil
      message.should_not be_valid
    end

    it 'should not be valid with an invalid tenant id' do
      message.tenant_id = 999
      message.should_not be_valid
    end

    it 'should not be valid without a conversation' do
      message.conversation = nil
      message.should_not be_valid
    end

    it 'should not be valid with an invalid conversation' do
      message.conversation_id = 999
      message.should_not be_valid
    end

    it 'should not be valid without text' do
      message.text = nil
      message.should_not be_valid
    end

    it 'should update the conversations engaged agent when the agent changes' do
      new_agent = create(:agent)
      create(:message, tenant: message.tenant, conversation: message.conversation, agent: new_agent)
      message.conversation.engaged_agent.should == new_agent
    end
  end
end