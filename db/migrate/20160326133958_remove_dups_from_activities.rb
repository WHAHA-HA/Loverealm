class RemoveDupsFromActivities < ActiveRecord::Migration
  def change
    execute <<-SQL
      DELETE FROM activities USING activities a2
  WHERE activities.owner_id = a2.owner_id AND
        activities.recipient_id = a2.recipient_id AND
        activities.key = 'relationship.create' AND
        activities.id < a2.id
    SQL
  end
end
