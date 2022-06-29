class AddAdditionalColumnsToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :started_at, :time
    add_column :appointments, :duration, :time
    add_column :appointments, :finished, :boolean
  end
end
