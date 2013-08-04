class Agent < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  belongs_to :tenant
  validates_presence_of :tenant
  validates_presence_of :display_name, :encrypted_password

  STATUS_UNAVAILABLE = 0
  STATUS_AVAILABLE = 1
  STATUS_NONRESPONSIVE = 2

  scope :by_email, lambda {|email| where('email = ?', email) }
  scope :by_tenant, lambda {|tenant| where('tenant_id = ?', tenant.id) }
  scope :unavailable, lambda {|| where('available = ?', STATUS_UNAVAILABLE) }
  scope :available, lambda {|| where('available = ?', STATUS_AVAILABLE) }
  scope :nonresponsive, lambda {|| where('available = ?', STATUS_NONRESPONSIVE) }

  before_validation :ensure_tenant

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

end
