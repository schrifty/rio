class Message < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :conversation
  validates_presence_of :tenant
  validates_presence_of :conversation
  validates_presence_of :text
end
