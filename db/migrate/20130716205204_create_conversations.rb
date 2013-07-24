class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :tenant_id
      t.boolean :active
      t.string :customer_id
      t.string :referer_url
      t.string :location
      t.string :customer_data
      t.integer :first_customer_message
      t.integer :target_agent_id
      t.integer :engaged_agent_id
      t.string :preferred_response_channel
      t.string :preferred_response_channel_info

      t.timestamps
    end
  end
end
