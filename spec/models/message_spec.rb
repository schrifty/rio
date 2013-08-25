require 'spec_helper'

describe Message do
  context 'creation' do
    before {
      @tenant1 = create(:tenant)
      @customer1 = create(:customer, :tenant => @tenant1)
      @conversation1 = create(:conversation, :tenant => @tenant1, :customer => @customer1)
      @agent1 = create(:agent, :tenant => @tenant1)
      @message1 = create(:message, :tenant => @tenant1, :conversation => @conversation1, :agent => nil)
      @message2 = create(:message, :tenant => @tenant1, :conversation => @conversation1, :agent => @agent1)
      @conversation1.first_message = @message1
      @conversation1.last_message = @message2
    }

    it 'should be valid' do
      @message1.should be_valid
    end

    it 'should not be valid without a tenant' do
      @message1.tenant = nil
      @message1.should_not be_valid
    end

    it 'should not be valid with an invalid tenant id' do
      @message1.tenant_id = 999
      @message1.should_not be_valid
    end

    it 'should not be valid without a conversation' do
      @message1.conversation = nil
      @message1.should_not be_valid
    end

    it 'should not be valid with an invalid conversation' do
      @message1.conversation_id = 999
      @message1.should_not be_valid
    end

    it 'should not be valid without text' do
      @message1.text = nil
      @message1.should_not be_valid
    end

    it 'should update the engaged agent when the agent changes' do
      create(:message, tenant: @message1.tenant, conversation: @message1.conversation, agent: @agent1)
      @message1.conversation.engaged_agent.should == @agent1
    end

    it 'should have the correct author_display_name when it was written by a customer' do
      @message1.author_display_name.should eq @customer1.display_name
    end

    it 'should have the correct author_display_name when it was written by an agent' do
      @message2.author_display_name.should eq @agent1.display_name
    end
  end
end