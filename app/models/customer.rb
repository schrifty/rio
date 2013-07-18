class Customer < ActiveRecord::Base
  belongs_to :tenant
  has_many :conversations

  validates_presence_of :tenant
end
