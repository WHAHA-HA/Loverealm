class CreateHashTagsContents < ActiveRecord::Migration
  def self.up
    create_table :contents_hash_tags, id: false do |t|
      t.references :hash_tag
      t.references :content
    end
    add_index :contents_hash_tags, [:hash_tag_id, :content_id]
    add_index :contents_hash_tags, :content_id
  end

  def self.down
    drop_table :contents_hash_tags
  end
end
