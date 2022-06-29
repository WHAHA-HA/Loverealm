class AddTagTypeToHashTags < ActiveRecord::Migration
  def change
    add_column :hash_tags, :type, :string
  end
end
