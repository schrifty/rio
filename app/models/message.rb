class Message < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :conversation
  validates_presence_of :tenant
  validates_presence_of :conversation
  validates_presence_of :text

  scope :by_tenant, lambda {|tenant_id| where('tenant_id = ?', tenant_id) unless tenant_id.nil? }
  scope :by_conversation, lambda {|conversation_id| where('conversation_id = ?', conversation_id) unless conversation_id.nil? }
  scope :since, lambda {|since| where('created_at > ?', since) unless since.nil? }
end
