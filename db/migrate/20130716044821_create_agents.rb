class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :tenant_id,          :null => false
      t.string :email,              :null => false
      t.string :encrypted_password, :null => false
      t.string :display_name,       :null => false
      t.integer :available,         :null => false, :default => false
      t.boolean :engaged,           :null => false, :default => false
      t.boolean :admin,             :null => false, :default => false
      t.string :xid
      t.timestamps
    end
  end
end
