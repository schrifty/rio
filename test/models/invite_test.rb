require 'test_helper'

class InviteTest < ActiveSupport::TestCase
  test "should save a valid invite" do
    invite = Invite.new({:tenant_id => tenants(:Tenant1).id, :recipient_email => "jdoe@gmail.com"})
    assert invite.save
  end

  test "that you can't create an invite with a duplicate id" do
    assert_raises ActiveRecord::RecordNotUnique do
      Invite.new(:id => invites(:Invite1).id, :tenant_id => tenants(:Tenant1).id, :recipient_email => "jdoe@gmail.com").save!
    end
  end

  test "should destroy a valid invite" do
    invites(:Invite1).destroy
    assert true
  end

  test "should not save without a tenant id" do
    invite = Invite.new({:recipient_email => "jdoe@gmail.com"})
    assert !invite.save
  end

  test "should not save with an invalid tenant id" do
    invite = Invite.new({:tenant_id => 1, :recipient_email => "jdoe@gmail.com"})
    assert !invite.save
  end

  test "should not save without a recipient email" do
    invite = Invite.new({:tenant_id => tenants(:Tenant1).id})
    assert !invite.save
  end
end
