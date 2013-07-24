class Message < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :conversation
  belongs_to :agent
  validates_presence_of :tenant
  validates_presence_of :conversation
  validates_presence_of :text

  scope :by_tenant, lambda {|tenant_id| where('tenant_id = ?', tenant_id) unless tenant_id.nil? }
  scope :by_conversation, lambda {|conversation_id| where('conversation_id = ?', conversation_id) unless conversation_id.nil? }
  scope :since, lambda {|since| where('created_at > ?', since) unless since.nil? }

  after_create :update_engaged_agent

  attr_reader :display_name

  def update_engaged_agent
    if self.agent && self.agent.id
      unless conversation.engaged_agent && conversation.engaged_agent.id == self.agent.id
        conversation.engaged_agent = self.agent
        conversation.save!
      end
    end
  end

  def display_name
    (agent && agent.display_name) || conversation.customer.display_name
  end

  def as_json(options={})
    super.as_json(options).merge({:display_name => display_name})
  end
end
