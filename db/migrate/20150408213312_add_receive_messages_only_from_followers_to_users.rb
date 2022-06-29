class AddReceiveMessagesOnlyFromFollowersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_messages_only_from_followers, :boolean, default: false
  end
end
