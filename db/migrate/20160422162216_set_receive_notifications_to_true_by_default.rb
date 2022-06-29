class SetReceiveNotificationsToTrueByDefault < ActiveRecord::Migration
  def change
    change_column :users, :receive_notification, :boolean, default: true
  end
end
