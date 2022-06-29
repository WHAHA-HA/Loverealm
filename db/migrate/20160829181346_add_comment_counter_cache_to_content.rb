class AddCommentCounterCacheToContent < ActiveRecord::Migration
  def change
    add_column :contents, :comments_count, :integer, default: 0
  end
end
