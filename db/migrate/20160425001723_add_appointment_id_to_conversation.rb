class AddAppointmentIdToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :appointment_id, :integer
  end
end
