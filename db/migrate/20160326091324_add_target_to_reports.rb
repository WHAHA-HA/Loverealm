class AddTargetToReports < ActiveRecord::Migration
  def change
    rename_column :reports, :user_id, :target_id
    add_column :reports, :target_type, :string
  end
end
