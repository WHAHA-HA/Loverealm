class AddDailyMessageToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :daily_message, :boolean, default: :false
  end
end
