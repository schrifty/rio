class Conversation < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :customer
  belongs_to :engaged_agent, :class_name => Agent
  belongs_to :target_agent, :class_name => Agent
  has_many :messages

  after_initialize :init

  validates_presence_of :tenant
  validates_presence_of :customer

  scope :by_tenant, lambda { |tenant| where('tenant_id = ?', tenant.id) }
  scope :by_active, lambda { |b| where("active = #{b ? '1' : '0'}") }
  scope :by_engaged, lambda { |b| where("engaged_agent_id is #{b ? 'not' : ''} null") }
  scope :needs_assignment, lambda {|| where('active = 1 AND engaged_agent_id is null').order('updated_at desc') }

  #attr_accessor :active, :referer_url, :preferred_response_channel, :preferred_response_channel_info

  def init
    self.active = true if self.active.nil?
  end
end
