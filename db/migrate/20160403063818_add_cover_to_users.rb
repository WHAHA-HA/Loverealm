class AddCoverToUsers < ActiveRecord::Migration
  def up
    add_attachment :users, :cover
  end

  def down
    remove_attachment :users, :cover
  end
end
