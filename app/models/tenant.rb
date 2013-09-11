class Tenant < ActiveRecord::Base
  has_many :agents
  has_many :customers
  has_many :conversations
  has_many :messages
  has_many :invites

  scope :in_demo_mode, lambda { where('demo_mode = 1', true) }

  validates_presence_of :display_name
end
