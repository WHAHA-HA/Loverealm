class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.references :mentee, index: true
      t.references :mentor, index: true

      t.timestamps null: false
    end
  end
end
