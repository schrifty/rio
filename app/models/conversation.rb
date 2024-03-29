class FKValidator < ActiveModel::Validator
  def validate(record)
    [:customer, :engaged_agent, :target_agent, :first_message, :last_message].each { |field|
      if record.send(field) && record.send(field).tenant != record.send(:tenant)
        record.errors[:base] << "#{field.to_s} cross-tenant access forbidden"
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

  before_validation :ensure_customer
  after_create :send_message_to_clients

  scope :by_id, lambda { |ids| where('conversations.id in (?)', ids) }
  scope :by_tenant, lambda { |tenant| where('conversations.tenant_id = ?', tenant.id) }
  scope :claimed_by, lambda { |id| where("conversations.lock = #{id}") }
  scope :unresolved, lambda { where('conversations.resolved = 0 OR conversations.resolved is null') }
  scope :resolved, lambda { where('conversations.resolved = 1') }
  scope :by_engaged, lambda { |b| where("conversations.engaged_agent_id is #{b ? 'not' : ''} null") }
  scope :needs_assignment, lambda { | | where('(conversations.resolved is null OR conversations.resolved = 0) AND conversations.engaged_agent_id is null').order('conversations.updated_at desc') }
  scope :agent_inbox, lambda { |agent|
    joins(:last_message).
    where('(conversations.resolved is null OR conversations.resolved = 0) AND (conversations.engaged_agent_id IS NULL OR (conversations.engaged_agent_id = ? AND messages.agent_id IS NULL)) AND conversations.lock IS NULL', agent.id).
    select('conversations.*')}
  scope :customer_inbox, lambda { |customer|
    joins(:last_message).
    where('(conversations.resolved is null OR conversations.resolved = 0) AND conversations.customer_id = ? AND messages.agent_id IS NOT NULL', customer.id)}

  attr_accessor :new_customer_display_name

  def ensure_customer
    unless self.customer
      self.customer = Customer.create!({:tenant => self.tenant, :display_name => self.new_customer_display_name})
    end
  end

  def claim(id)
    self.lock = id
    self.save!
  end

  def send_message_to_clients
    channel_name = "conversations-tenant-#{self.tenant.id}"
    WebsocketRails[channel_name.to_sym].trigger 'new', self.to_json(:methods => [:customer_display_name, :engaged_agent_name] )
  end

  def message_count
    self.messages.size
  end

  def customer_display_name
    self.customer && self.customer.display_name
  end

  def engaged_agent_name
    (self.engaged_agent && self.engaged_agent.display_name) || ''
  end

  def last_message_author_role
    self.last_message.author_role
  end

  def last_message_author_display_name
    self.last_message.author_display_name
  end

  def last_message_text
    self.last_message.text
  end

  def last_message_created_at
    self.last_message.created_at
  end
end
