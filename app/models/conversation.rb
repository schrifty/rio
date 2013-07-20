class Conversation < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :customer
  has_many :messages
  has_one :engaged_agent, :class_name => Agent

  validates_presence_of :tenant
  validates_presence_of :customer

  attr_accessor :active, :referer_url, :engaged_agent, :preferred_response_channel, :preferred_response_channel_info
end
