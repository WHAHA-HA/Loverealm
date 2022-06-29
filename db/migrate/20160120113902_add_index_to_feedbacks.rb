class AddIndexToFeedbacks < ActiveRecord::Migration
  def change
    add_index :feedbacks, :checked
  end
end
