class AddNotificationsCheckedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notifications_checked_at, :datetime
    User.update_all notifications_checked_at: Time.now
  end
end
