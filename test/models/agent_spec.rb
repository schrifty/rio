require "spec_helper"

describe Agent do
  before do
    @tenant1 = create(:tenant)
    @tenant2 = create(:tenant)
  end

  describe 'creation' do
    let(:agent) { build(:agent) }

    it 'should not create an agent without a tenant id' do
      agent.tenant = nil
      agent.should_not be_valid
    end

    it 'should not create an agent without a display name' do
      agent.display_name = nil
      agent.should_not be_valid
    end

    it 'should not create an agent without an encrypted password' do
      agent.encrypted_password = nil
      agent.should_not be_valid
    end
  end

  describe 'scoping' do
    context 'tenant scoping' do
      it 'should return the correct results for a given tenant' do
        agent1 = create(:agent, tenant: @tenant1)
        agent2 = create(:agent, tenant: @tenant2)
        Agent.by_tenant(@tenant1).should include(agent1)
        Agent.by_tenant(@tenant1).should_not include(agent2)
        Agent.by_tenant(@tenant1).size.should == Agent.where('tenant_id = ?', @tenant1.id).size
      end
    end

    context 'availability scoping' do
      it 'should return the correct number of results for a given tenant' do
        agent1 = create(:agent, tenant: @tenant1, available: 1)
        agent2 = create(:agent, tenant: @tenant1, available: 0)

        Agent.by_tenant(@tenant1).available.should include(agent1)
        Agent.by_tenant(@tenant1).available.should_not include(agent2)
        Agent.by_tenant(@tenant1).unavailable.should_not include(agent1)
        Agent.by_tenant(@tenant1).unavailable.should include(agent2)
      end
    end
  end
end