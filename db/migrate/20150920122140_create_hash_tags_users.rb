class CreateHashTagsUsers < ActiveRecord::Migration
  def self.up
    create_table :hash_tags_users, id: false do |t|
      t.references :hash_tag
      t.references :user
    end
    add_index :hash_tags_users, [:hash_tag_id, :user_id]
    add_index :hash_tags_users, :user_id
  end

  def self.down
    drop_table :hash_tags_users
  end
end
