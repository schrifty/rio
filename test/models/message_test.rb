require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test 'should save a valid message' do
    message = Message.new({:tenant_id => tenants(:Tenant1).id, :conversation_id => conversations(:Tenant1Conversation1).id, :text => 'blah'})
    assert message.save
  end

  test 'should not create a message with a duplicate id' do
    assert_raises ActiveRecord::RecordNotUnique do
      Message.new(:id => messages(:Tenant1Conv1Message1).id, :tenant_id => tenants(:Tenant1).id, :conversation_id => conversations(:Tenant1Conversation1).id, :text => 'blah').save!
    end
  end

  test 'should not save a message without a tenant id' do
    message = Message.new({:conversation_id => 1, :text => 'blah'})
    assert !message.save
  end

  test 'should not save a message with an invalid tenant id' do
    message = Message.new({:tenant_id => 999, :conversation_id => 1, :text => 'blah'})
    assert !message.save
  end

  test 'should not save a message without a conversation_id' do
    message = Message.new({:tenant_id => 1, :text => 'blah'})
    assert !message.save
  end

  test 'should not save a message with an invalid conversation_id' do
    message = Message.new({:tenant_id => 1, :conversation_id => 999, :text => 'blah'})
    assert !message.save
  end

  test 'should not save a message without text' do
    message = Message.new({:tenant_id => 1, :conversation_id => 1})
    assert !message.save
  end

  test 'should update the conversation.engaged_agent_id if it is different that latest one' do
    conversation = conversations(:Tenant2Conversation1_NoAgent)
    assert_nil conversation.engaged_agent
    Message.new({:tenant_id => tenants(:Tenant2).id, :conversation_id => conversation.id, :agent_id => agents(:Agent1).id, :text => 'ipsum lorem'}).save!
    assert conversation.reload.engaged_agent
    assert_equal conversation.engaged_agent.display_name, agents(:Agent1).display_name
  end
end
