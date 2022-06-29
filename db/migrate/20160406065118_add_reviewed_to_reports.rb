class AddReviewedToReports < ActiveRecord::Migration
  def change
    add_column :reports, :reviewed, :boolean, default: false
    Report.update_all(target_type: 'User')
  end
end
