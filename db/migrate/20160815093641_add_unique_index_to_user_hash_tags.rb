class AddUniqueIndexToUserHashTags < ActiveRecord::Migration
  # def up
  #   # replace default index with unique index
  #   remove_index :hash_tags_users, name: :index_hash_tags_users_on_hash_tag_id_and_user_id
  #   add_index :hash_tags_users, [:hash_tag_id, :user_id], unique: true
  # end

  # def down
  #   remove_index :hash_tags_users, name: :index_hash_tags_users_on_hash_tag_id_and_user_id
  #   add_index :hash_tags_users, [:hash_tag_id, :user_id]
  # end
end
