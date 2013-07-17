require 'test_helper'

class TenantTest < ActiveSupport::TestCase
  test "that you can create a tenant" do
    tenant = Tenant.new(:email => "tenant@gmail.com", :twitter_id => "tenant")
    assert tenant.save!
  end
end
