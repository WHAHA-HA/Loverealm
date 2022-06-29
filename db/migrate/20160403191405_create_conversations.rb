class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :participants, array: :true, default: []
      t.timestamps null: false
    end
  end
end
