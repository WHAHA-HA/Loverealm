class CreatePhoneNumberInvitations < ActiveRecord::Migration
  def change
    create_table :phone_number_invitations do |t|
      t.belongs_to :user
      t.string :phone_number
      t.timestamps
    end

    add_index :phone_number_invitations, :phone_number
  end
end
