class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :tenant_id
      t.string :conversation_id
      t.string :agent_id
      t.string :sent_by
      t.string :text

      t.timestamps
    end
  end
end
