#!/usr/bin/env ruby
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

while true do
  if conversation = Conversation.needs_assignment.first
    puts "Found an unengaged conversation [#{conversation.id}]"
    agents = Agent.by_tenant(conversation.tenant).available
    unless agents.empty?
      target_agent = agents.first
      conversation.target_agent = target_agent
      conversation.save!
      puts "Attempting to contact agent [#{target_agent.display_name}]"
      unless target_agent.contact
        puts "Agent [#{target_agent.display_name}] failed to respond"
        target_agent.mark_as_unresponsive
        conversation.target_agent = nil
        conversation.save!
      end
    else
      puts 'No available agents'
      sleep(1)
    end
  else
    puts 'No unengaged conversations found'
    sleep(1)
  end
end