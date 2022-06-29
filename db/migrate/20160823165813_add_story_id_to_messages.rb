class AddStoryIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :story_id, :integer
  end
end
