require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  test "should save a valid customer" do
    customer = Customer.new({:tenant_id => tenants(:Tenant1).id, :display_name => "John Doe"})
    assert customer.save
  end

  test "that you can't create a customer with a duplicate id" do
    assert_raises ActiveRecord::RecordNotUnique do
      Customer.new(:id => customers(:Customer1).id, :tenant_id => tenants(:Tenant1).id, :display_name => "John Doe").save!
    end
  end

  test "should not save without a tenant id" do
    customer = Customer.new({:display_name => "James Doe"})
    assert !customer.save
  end

  test "should not save with an invalid tenant id" do
    customer = Customer.new({:tenant_id => 999, :display_name => "James Doe"})
    assert !customer.save
  end
end
