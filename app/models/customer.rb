class Customer < ActiveRecord::Base
  belongs_to :tenant
  has_many :conversations

  validates_presence_of :tenant

  scope :by_tenant, lambda {|tenant| where('tenant_id = ?', tenant.id) }
end
