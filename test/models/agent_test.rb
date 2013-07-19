require 'test_helper'

class AgentTest < ActiveSupport::TestCase
  test "should save a valid agent" do
    agent = Agent.new({:tenant_id => tenants(:Tenant1).id, :display_name => "John Doe", :encrypted_password => "blech"})
    assert agent.save
  end

  test "that you can't create an agent with a duplicate id" do
    assert_raises ActiveRecord::RecordNotUnique do
      Agent.new(:id => agents(:Agent1).id, :tenant_id => tenants(:Tenant1).id, :display_name => "John Doe", :encrypted_password => "blech").save!
    end
  end

  test "should not save without a tenant id" do
    agent = Agent.new({:display_name => "James Doe", :encrypted_password => "blech"})
    assert !agent.save
  end

  test "should not save with an invalid tenant id" do
    agent = Agent.new({:tenant_id => 999, :display_name => "James Doe", :encrypted_password => "blech"})
    assert !agent.save
  end

  test "should not save without a display name" do
    agent = Agent.new({:tenant_id => tenants(:Tenant1).id, :encrypted_password => "blech"})
    assert !agent.save
  end

  test "should not save without a password" do
    agent = Agent.new({:tenant_id => tenants(:Tenant1).id, :display_name => "Jane Doe"})
    assert !agent.save
  end
end
