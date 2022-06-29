class AddRemovedAtToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :removed_at, :datetime
  end
end
