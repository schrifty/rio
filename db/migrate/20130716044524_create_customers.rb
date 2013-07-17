class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :tenant_id
      t.string :display_name

      t.timestamps
    end
  end
end
