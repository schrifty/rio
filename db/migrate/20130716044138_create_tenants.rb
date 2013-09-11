class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.string :display_name
      t.string :twitter_id
      t.string :email
      t.integer :demo_mode, :null => false, :default => 0

      t.timestamps
    end
  end
end
