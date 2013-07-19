require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  test "should save a valid conversation" do
    conversation = Conversation.new({:tenant_id => tenants(:Tenant1).id, :customer_id => customers(:Customer1).id})
    assert conversation.save
  end

  test "should not save without a tenant id" do
    conversation = Conversation.new({:customer_id => customers(:Customer1).id})
    assert !conversation.save
  end

  test "that you can't create a conversation with a duplicate id" do
    assert_raises ActiveRecord::RecordNotUnique do
      Conversation.new(:id => conversations(:Tenant1Conversation1).id, :tenant_id => tenants(:Tenant1).id, :customer_id => customers(:Customer1).id).save!
    end
  end

  test "should not save with an invalid tenant id" do
    conversation = Conversation.new({:tenant_id => 999, :customer_id => customers(:Customer1).id})
    assert !conversation.save
  end

  test "should not save without a customer id" do
    conversation = Conversation.new({:tenant_id => tenants(:Tenant1).id})
    assert !conversation.save
  end

  test "should not save with an invalid customer id" do
    conversation = Conversation.new({:tenant_id => tenants(:Tenant1).id, :customer_id => 999})
    assert !conversation.save
  end
end
