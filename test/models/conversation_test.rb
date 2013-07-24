require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  test 'should save a valid conversation' do
    conversation = Conversation.new({:tenant_id => tenants(:Tenant1).id, :customer_id => customers(:Customer1).id})
    assert conversation.save
  end

  test 'should not save without a tenant id' do
    conversation = Conversation.new({:customer_id => customers(:Customer1).id})
    assert !conversation.save
  end

  test 'that you cannot create a conversation with a duplicate id' do
    assert_raises ActiveRecord::RecordNotUnique do
      Conversation.new(:id => conversations(:Tenant1Conversation1).id, :tenant_id => tenants(:Tenant1).id, :customer_id => customers(:Customer1).id).save!
    end
  end

  test 'should not save with an invalid tenant id' do
    conversation = Conversation.new({:tenant_id => 999, :customer_id => customers(:Customer1).id})
    assert !conversation.save
  end

  test 'should not save without a customer id' do
    conversation = Conversation.new({:tenant_id => tenants(:Tenant1).id})
    assert !conversation.save
  end

  test 'should not save with an invalid customer id' do
    conversation = Conversation.new({:tenant_id => tenants(:Tenant1).id, :customer_id => 999})
    assert !conversation.save
  end

  test 'should return only conversations belonging to a certain tenant' do
    assert_equal Conversation.where('tenant_id = ?', tenants(:Tenant1).id).size, Conversation.by_tenant(tenants(:Tenant1)).size
  end

  test 'should return an accurate number of engaged conversations' do
    assert_equal Conversation.where('engaged_agent_id is not null').size, Conversation.by_engaged(true).size
    assert_equal Conversation.where('engaged_agent_id is null').size, Conversation.by_engaged(false).size
  end

  test 'should return an accurate number of active conversations' do
    assert_equal Conversation.where('active = 1').size, Conversation.by_active(true).size
    assert_equal Conversation.where('active = 0').size, Conversation.by_active(false).size
  end

  test 'should return the next conversation that needs assignment' do
    found_conversation = Conversation.needs_assignment.first
    correct_conversation = Conversation.where('active = 1 AND engaged_agent_id is null').order('updated_at desc').first
    assert_equal found_conversation, correct_conversation
  end
end
