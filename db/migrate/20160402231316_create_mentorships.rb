class CreateMentorships < ActiveRecord::Migration
  def change
    create_table :mentorships do |t|
      t.integer :mentor_id, index: true
      t.integer :hash_tag_id, index: true
      t.timestamps null: false
    end
  end
end
