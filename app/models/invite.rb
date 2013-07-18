class Invite < ActiveRecord::Base
  belongs_to :tenant
  validates_presence_of :tenant
  validates_presence_of :recipient_email
end
