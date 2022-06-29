class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject
      t.text :body
      t.integer :receiver_id
      t.integer :sender_id

      t.timestamps
    end
  end
end
