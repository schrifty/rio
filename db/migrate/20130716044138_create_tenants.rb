class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.string :twitter_id
      t.string :email

      t.timestamps
    end
  end
end
