class Tenant < ActiveRecord::Base
  has_many :agents
  has_many :customers
  has_many :conversations
  has_many :messages
  has_many :invites

  validates_presence_of :display_name
end
