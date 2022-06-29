class CreateHashTags < ActiveRecord::Migration
  def change
    create_table :hash_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
