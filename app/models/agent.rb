class Agent < ActiveRecord::Base
  belongs_to :tenant
  validates_presence_of :tenant
  validates_presence_of :display_name, :encrypted_password
end
