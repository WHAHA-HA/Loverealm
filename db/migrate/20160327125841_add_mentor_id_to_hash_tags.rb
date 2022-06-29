class AddMentorIdToHashTags < ActiveRecord::Migration
  def change
    add_column :hash_tags, :mentor_id, :integer
  end
end
