class AddContentIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :content_id, :integer
  end
end
