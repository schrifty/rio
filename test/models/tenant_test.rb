require 'test_helper'

class TenantTest < ActiveSupport::TestCase
  test "that you can create a tenant" do
    tenant = Tenant.new(:email => "tenant@gmail.com", :twitter_id => "tenant")
    assert tenant.save!
  end

  test "that you can't create a tenant with a duplicate id" do
    assert_raises ActiveRecord::RecordNotUnique do
      Tenant.new(:id => 1).save!
    end
  end
end
