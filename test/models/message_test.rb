require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test "should save a valid message" do
    message = Message.new({:tenant_id => 1, :conversation_id => 1, :text => "blah"})
    assert message.save
  end

  test "that you can't create a message with a duplicate id" do
    assert_raises ActiveRecord::RecordNotUnique do
      Message.new(:id => 1, :tenant_id => 1, :conversation_id => 1, :text => "blah").save!
    end
  end

  test "should not save without a tenant id" do
    message = Message.new({:conversation_id => 1, :text => "blah"})
    assert !message.save
  end

  test "should not save with an invalid tenant id" do
    message = Message.new({:tenant_id => 999, :conversation_id => 1, :text => "blah"})
    assert !message.save
  end

  test "should not save without a conversation_id" do
    message = Message.new({:tenant_id => 1, :text => "blah"})
    assert !message.save
  end

  test "should not save without an invalid conversation_id" do
    message = Message.new({:tenant_id => 1, :conversation_id => 999, :text => "blah"})
    assert !message.save
  end

  test "should not save without text" do
    message = Message.new({:tenant_id => 1, :conversation_id => 1})
    assert !message.save
  end
end
