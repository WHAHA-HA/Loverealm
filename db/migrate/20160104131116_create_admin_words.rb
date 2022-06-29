class CreateAdminWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :name

      t.timestamps
    end
  end
end
