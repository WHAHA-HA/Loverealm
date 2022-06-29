class AddIsNewbieToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_newbie, :boolean, default: :true
  end
end
