class AddIndexToHashTag < ActiveRecord::Migration
  def change
    add_index :hash_tags, :name
  end
end
