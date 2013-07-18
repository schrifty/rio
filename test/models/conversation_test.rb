require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  test "should save a valid conversation" do
    conversation = Conversation.new({:tenant_id => 1, :customer_id => 1})
    assert conversation.save
  end

  test "should not save without a tenant id" do
    conversation = Conversation.new({:customer_id => 1})
    assert !conversation.save
  end

  test "that you can't create a conversation with a duplicate id" do
    assert_raises ActiveRecord::RecordNotUnique do
      Conversation.new(:id => 1, :tenant_id => 1, :customer_id => 1).save!
    end
  end

  test "should not save with an invalid tenant id" do
    conversation = Conversation.new({:tenant_id => 999, :customer_id => 1})
    assert !conversation.save
  end

  test "should not save without a customer id" do
    conversation = Conversation.new({:tenant_id => 1})
    assert !conversation.save
  end

  test "should not save with an invalid customer id" do
    conversation = Conversation.new({:tenant_id => 1, :customer_id => 999})
    assert !conversation.save
  end
end
