class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :tenant_id
      t.string :recipient_email

      t.timestamps
    end
  end
end
