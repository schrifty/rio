require "spec_helper"

describe Conversation do
  before do
    @tenant1 = create(:tenant)
    @tenant2 = create(:tenant)

    @agent1 = create(:agent, :tenant => @tenant1)

    @customer1 = create(:customer, :tenant => @tenant1)
    @customer2 = create(:customer, :tenant => @tenant2)
  end

  context 'creation' do
    before {
      @conversation1 = build(:conversation, :tenant => @tenant1, :customer => @customer1)
      @message1 = build(:message, :tenant => @tenant1, :conversation => @conversation1)
      @conversation1.first_message = @message1
      @message2 = build(:message, :tenant => @tenant1, :conversation => @conversation1, :agent_id => @agent1)
      @conversation1.last_message = @message2
      @conversation2 = build(:conversation, :tenant => @tenant2, :customer => @customer2)
      @conversation2.first_message = build(:message, :tenant => @tenant2, :conversation => @conversation2)
      @conversation2.last_message = build(:message, :tenant => @tenant2, :conversation => @conversation2)
    }

    it 'should build a valid conversation' do
      @conversation1.should be_valid
    end

    it 'should not be valid without a tenant' do
      @conversation1.tenant = nil
      @conversation1.should_not be_valid
    end

    it 'should implicitly create a customer if one is bot passed in with the conversation' do
      @conversation2.customer = nil
      @conversation2.save!
      @conversation2.customer.should_not be_nil
    end

    it 'should set the correct display name for the implicitly created customer' do
      display_name = 'Mickey Rourke'
      @conversation2.new_customer_display_name = display_name
      @conversation2.customer = nil
      @conversation2.save!
      @conversation2.customer_display_name.should eq display_name
    end

    it 'should set the correct tenant for the implicitly created customer' do
      @conversation2.customer = nil
      @conversation2.save!
      @conversation2.tenant.should eq @conversation2.tenant
    end

    it 'should not be valid with an invalid tenant id' do
      @conversation1.tenant_id = 99999
      @conversation1.should_not be_valid
    end

    it 'should not be valid with a first_message that belongs to another tenant' do
      @conversation1.first_message = @conversation2.first_message
      @conversation1.should_not be_valid
    end

    it 'should not be valid with a last_message that belongs to another tenant' do
      @conversation1.last_message = @conversation2.last_message
      @conversation1.should_not be_valid
    end

    it 'should have the correct customer display name' do
      @conversation1.customer_display_name.should eq @customer1.display_name
    end

    it 'should have the correct last_message_author_display_name' do
      @conversation1.last_message_author_display_name.should eq @agent1.display_name
    end

    it 'should have the correct last_message_created_at' do
      @conversation1.last_message_created_at.should eq @conversation1.last_message.created_at
    end
  end

  context 'scoping' do
    it 'should return only conversations belonging to a certain tenant' do
      conversation1 = create(:conversation, tenant: @tenant1, customer: @customer1)
      conversation2 = create(:conversation, tenant: @tenant2, customer: @customer2)
      Conversation.by_tenant(@tenant1).should include(conversation1)
      Conversation.by_tenant(@tenant1).should_not include(conversation2)
    end

    it 'should return an accurate number of engaged conversations' do
      conversation1 = create(:conversation, tenant: @tenant1, customer: @customer1, engaged_agent: @agent1)
      conversation2 = create(:conversation, tenant: @tenant1, customer: @customer1, engaged_agent: nil)
      Conversation.by_engaged(true).should include(conversation1)
      Conversation.by_engaged(true).should_not include(conversation2)
    end

    it 'should return an accurate number of active conversations' do
      conversation1 = create(:conversation, tenant: @tenant1, customer: @customer1, resolved: false)
      conversation2 = create(:conversation, tenant: @tenant1, customer: @customer1, resolved: true)
      Conversation.unresolved.should include(conversation1)
      Conversation.unresolved.should_not include(conversation2)
      Conversation.resolved.should_not include(conversation1)
      Conversation.resolved.should include(conversation2)
    end

    it 'should return the next conversation that needs assignment' do
      conversation1 = create(:conversation, tenant: @tenant1, customer: @customer1, resolved: false, engaged_agent: @agent1)
      conversation2 = create(:conversation, tenant: @tenant1, customer: @customer1, resolved: true, engaged_agent: nil)
      conversation3 = create(:conversation, tenant: @tenant1, customer: @customer1, resolved: false, engaged_agent: nil, updated_at: "2013-07-15 10:06:22")
      conversation4 = create(:conversation, tenant: @tenant1, customer: @customer1, resolved: false, engaged_agent: nil, updated_at: "2013-07-15 12:06:22")
      conversation5 = create(:conversation, tenant: @tenant1, customer: @customer1, resolved: false, engaged_agent: nil, updated_at: "2013-07-15 11:06:22")
      conv = Conversation.needs_assignment.first
      conv.should_not == conversation1
      conv.should_not == conversation2
      conv.should_not == conversation3
      conv.should_not == conversation5
      conv.should == conversation4
    end
  end
end