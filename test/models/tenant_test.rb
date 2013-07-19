require 'test_helper'

class TenantTest < ActiveSupport::TestCase
  test 'that you can create a tenant' do
    tenant = Tenant.new(:email => 'tenant@gmail.com', :twitter_id => 'tenant')
    assert tenant.save!
  end

  test 'that you cannot create a tenant with a duplicate id' do
    assert_raises ActiveRecord::RecordNotUnique do
      Tenant.new(:id => tenants(:Tenant1).id).save!
    end
  end
end
