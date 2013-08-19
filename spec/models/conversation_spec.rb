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
    let(:conversation) { build(:conversation, :tenant => @tenant1, :customer => @customer1) }

    it 'should build a valid conversation' do
      conversation.should be_valid
    end

    it 'should not be valid without a tenant' do
      conversation.tenant = nil
      conversation.should_not be_valid
    end

    it 'should not be valid without a customer' do
      conversation.customer = nil
      conversation.should_not be_valid
    end

    it 'should not be valid with an invalid tenant id' do
      conversation.tenant_id = 99999
      conversation.should_not be_valid
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
      conversation1 = create(:conversation, tenant: @tenant1, customer: @customer1, active: true)
      conversation2 = create(:conversation, tenant: @tenant1, customer: @customer1, active: false)
      Conversation.by_active(true).should include(conversation1)
      Conversation.by_active(true).should_not include(conversation2)
      Conversation.by_active(false).should_not include(conversation1)
      Conversation.by_active(false).should include(conversation2)
    end

    it 'should return the next conversation that needs assignment' do
      conversation1 = create(:conversation, tenant: @tenant1, customer: @customer1, active: true, engaged_agent: @agent1)
      conversation2 = create(:conversation, tenant: @tenant1, customer: @customer1, active: false, engaged_agent: nil)
      conversation3 = create(:conversation, tenant: @tenant1, customer: @customer1, active: true, engaged_agent: nil, updated_at: "2013-07-15 10:06:22")
      conversation4 = create(:conversation, tenant: @tenant1, customer: @customer1, active: true, engaged_agent: nil, updated_at: "2013-07-15 12:06:22")
      conversation5 = create(:conversation, tenant: @tenant1, customer: @customer1, active: true, engaged_agent: nil, updated_at: "2013-07-15 11:06:22")
      conv = Conversation.needs_assignment.first
      conv.should_not == conversation1
      conv.should_not == conversation2
      conv.should_not == conversation3
      conv.should_not == conversation5
      conv.should == conversation4
    end
  end
end