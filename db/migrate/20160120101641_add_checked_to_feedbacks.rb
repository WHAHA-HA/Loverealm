class AddCheckedToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :checked, :boolean, default: false
  end
end
