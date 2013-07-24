describe Agent do
  before do
    @tenant1 = Tenant.create!( {:email => 'tenant@gmail.com', :twitter_id => 'tenant'} )
  end

  describe '.create' do
    before do
      @agent1 = Agent.create!({:tenant => @tenant1, :display_name => 'John', :encrypted_password => 'xyzzy'})
    end

    it 'should not create an agent with a duplicate id' do
      Agent.create!({:id => @agent1.id, :tenant => @tenant1, :display_name => 'James', :encrypted_password => 'bletch'})
    end

    it 'should not create an agent without a tenant id' do
      Agent.create!({:display_name => 'James', :encrypted_password => 'bletch'})
    end

    it 'should not create an agent without a display name' do
      Agent.create!({:tenant => @tenant1, :encrypted_password => 'bletch'})
    end

    it 'should not create an agent without a password' do
      Agent.create!({:tenant => @tenant1, :display_name => 'James'})
    end
  end
end

require 'test_helper'

class AgentTest < ActiveSupport::TestCase
  test 'should save a valid agent' do
    agent = Agent.new({:tenant_id => tenants(:Tenant1).id, :display_name => 'John Doe', :encrypted_password => 'blech'})
    assert agent.save
  end

  test('that you cannot create an agent with a duplicate id') do
    assert_raises ActiveRecord::RecordNotUnique do
      Agent.new(:id => agents(:Agent1).id, :tenant_id => tenants(:Tenant1).id, :display_name => 'John Doe', :encrypted_password => 'blech').save!
    end
  end

  test 'should not save without a tenant id' do
    agent = Agent.new({:display_name => 'James Doe', :encrypted_password => 'blech'})
    assert !agent.save
  end

  test 'should not save with an invalid tenant id' do
    agent = Agent.new({:tenant_id => 999, :display_name => 'James Doe', :encrypted_password => 'blech'})
    assert !agent.save
  end

  test 'should not save without a display name' do
    agent = Agent.new({:tenant_id => tenants(:Tenant1).id, :encrypted_password => 'blech'})
    assert !agent.save
  end

  test 'should not save without a password' do
    agent = Agent.new({:tenant_id => tenants(:Tenant1).id, :display_name => 'Jane Doe'})
    assert !agent.save
  end

  test 'available scope should return only agents of the correct tenant' do
    assert_equal Agent.by_tenant(tenants(:Tenant1)).size, Agent.where('tenant_id = ?', tenants(:Tenant1).id).size
  end

  test 'available scope should return only available agents' do
    scope = Agent.by_tenant(tenants(:Tenant1))
    assert_equal scope.available.size, Agent.where('tenant_id = ? AND available = 1', tenants(:Tenant1).id).size
    assert_equal scope.unavailable.size, Agent.where('tenant_id = ? AND available = 0', tenants(:Tenant1).id).size
  end


end
