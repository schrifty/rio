class FKValidator < ActiveModel::Validator
  def validate(record)
    [:customer, :engaged_agent, :target_agent, :first_message, :last_message].each { |field|
      if record.send(field) && record.send(field).tenant != record.send(:tenant)
        record.errors[:base] << "#{field.to_s} access forbidden"
      end
    }
  end
end

class Conversation < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :customer
  belongs_to :engaged_agent, :class_name => Agent
  belongs_to :target_agent, :class_name => Agent
  belongs_to :first_message, :class_name => Message
  belongs_to :last_message, :class_name => Message
  has_many :messages

  validates_presence_of :tenant, :customer
  validates_with FKValidator, fields: [:customer, :engaged_agent, :target_agent, :first_message, :last_message]

  scope :by_tenant, lambda { |tenant| where('tenant_id = ?', tenant.id) }
  scope :unresolved, lambda { where('resolved = 0') }
  scope :resolved, lambda { where('resolved = 1') }
  scope :by_engaged, lambda { |b| where("engaged_agent_id is #{b ? 'not' : ''} null") }
  scope :needs_assignment, lambda { | | where('resolved = 0 AND engaged_agent_id is null').order('updated_at desc') }

  def message_count
    self.messages.size
  end

  def customer_display_name
    self.customer.display_name
  end

  def last_message_author_display_name
    self.last_message.author_display_name
  end

  def last_message_created_at
    self.last_message.created_at
  end
end
