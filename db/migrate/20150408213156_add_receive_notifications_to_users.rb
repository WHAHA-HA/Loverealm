class AddReceiveNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_notification, :boolean, default: false
  end
end
