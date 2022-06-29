class CreateMobileTokens < ActiveRecord::Migration
  def change
    create_table :mobile_tokens do |t|
      t.belongs_to :user, index: true
      t.string :device_token
      t.string :fcm_token

      t.timestamps null: false
    end
    add_foreign_key :mobile_tokens, :users
  end
end
