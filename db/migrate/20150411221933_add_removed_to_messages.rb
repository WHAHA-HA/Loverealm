class AddRemovedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :removed, :boolean, default: false
  end
end
