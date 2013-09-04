class Message < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  belongs_to :tenant
  belongs_to :conversation
  belongs_to :agent
  validates_presence_of :tenant
  validates_presence_of :conversation
  validates_presence_of :text

  scope :by_tenant, lambda { |tenant_id| where('tenant_id = ?', tenant_id) unless tenant_id.nil? }
  scope :by_conversation, lambda { |conversation_id| where('conversation_id = ?', conversation_id) unless conversation_id.nil? }
  scope :since, lambda { |since| where('created_at > ?', since) unless since.nil? }

  after_create :update_conversation_after_create
  after_create :send_message_to_clients

  # elasticsearch
  def type
    'message'
  end

  def to_indexed_json
    self.to_json( { :only => [:display_name, :email] } )
  end

  mapping do
    indexes :display_name
    indexes :email
  end

  def author_role
    self.agent_id ? 'agent' : 'customer'
  end

  def author_display_name
    (agent && agent.display_name) || conversation.customer.display_name
  end

  # this query depends upon ids being sequential - if we convert the message id to a guid (no reason to think we would) this will break
  def self.need_response(rows)
    Message.find_by_sql("select b.* from (select MAX(id) as mid from messages where agent_id is null group by conversation_id) a join messages b on a.mid = b.id order by updated_at limit #{rows}")
  end

  def update_conversation_after_create
    self.conversation.engaged_agent = self.agent
    self.conversation.first_message ||= self
    self.conversation.last_message = self
    self.conversation.save!
  end

  def send_message_to_clients
    channel_name = "messages-tenant-#{self.tenant.id}"
    WebsocketRails[channel_name.to_sym].trigger 'new', self.to_json( {:methods => [:author_role, :author_display_name]} )
  end
end
