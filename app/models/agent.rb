class Agent < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable # :rememberable,

  belongs_to :tenant
  validates_presence_of :tenant
  validates_presence_of :display_name, :encrypted_password

  # the status of the agent
  STATUS_UNAVAILABLE = 0
  STATUS_AVAILABLE = 1
  STATUS_NONRESPONSIVE = 2

  # the max number of simultaneous conversations an agent is capable of fielding
  MAX_CONV_COUNT = 3

  scope :by_email, lambda {|email| where('email = ?', email) }
  scope :by_tenant, lambda {|tenant| where('tenant_id = ?', tenant.id) }
  scope :unavailable, lambda {|| where('available = ?', STATUS_UNAVAILABLE) }
  scope :available, lambda {|| where('available = ?', STATUS_AVAILABLE) }
  scope :nonresponsive, lambda {|| where('available = ?', STATUS_NONRESPONSIVE) }

  default_scope order("if(available = #{STATUS_AVAILABLE}, 0, if(available = #{STATUS_NONRESPONSIVE}, 1, 2))")

  before_validation :ensure_tenant
  after_create :send_message_to_clients

  # for tire/elasticsearch
  def type
    'agent'
  end

  # for tire/elasticsearch
  def to_indexed_json
    self.to_json( { :only => [:text] } )
  end

  # for tire/elasticsearch
  mapping do
    indexes :text
  end

  def as_json(options = nil)
    super(:methods => [:last_sign_in_at, :customer_count, :status, :demo_mode] )
  end

  attr_reader :status
  def status
    if self.available == STATUS_AVAILABLE
      if self.customer_count > MAX_CONV_COUNT
        "engaged"
      else
        "available"
      end
    elsif self.available == STATUS_NONRESPONSIVE
      "nonresponsive"
    else
      "unavailable"
    end
  end

  attr_reader :customer_count
  def customer_count
    [0, rand(20) - 10].max
  end

  def demo_mode
    self.tenant.demo_mode
  end

  def ensure_tenant
    unless self.tenant
      self.tenant = Tenant.create({:display_name => self.display_name, :email => self.email})
    end
  end

  # contact the agent by whatever means necessary
  def contact
    sleep(5)
    return false
  end

  # when an agent fails to respond to a question, we mark him as unavailable
  def mark_as_unresponsive
    self.available = STATUS_NONRESPONSIVE
    save!
  end

  def send_message_to_clients
    channel_name = "agents-tenant-#{self.tenant.id}"
    WebsocketRails[channel_name.to_sym].trigger 'new', self.to_json(:methods => [:status, :customer_count] )
  end
end
