class Conversation < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :customer
  has_many :messages

  validates_presence_of :tenant
  validates_presence_of :customer
end
