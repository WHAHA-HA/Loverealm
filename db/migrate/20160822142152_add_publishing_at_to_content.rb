class AddPublishingAtToContent < ActiveRecord::Migration
  def change
    add_column :contents, :publishing_at, :datetime
  end
end
