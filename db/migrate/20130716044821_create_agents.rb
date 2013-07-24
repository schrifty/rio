class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :tenant_id
      t.string :email
      t.string :encrypted_password
      t.string :display_name
      t.integer :available
      t.boolean :engaged
      t.string :xid
      t.boolean :admin
      t.timestamps
    end
  end
end
