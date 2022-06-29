class AddPasswordConfirmationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_confirmations, :string
  end
end
