class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :tenant_id
      t.boolean :available
      t.boolean :engaged
      t.string :display_name
      t.string :encrypted_password
      t.string :xid
      t.boolean :admin

      t.timestamps
    end
  end
end
