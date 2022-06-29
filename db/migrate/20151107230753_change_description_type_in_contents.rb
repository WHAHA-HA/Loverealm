class ChangeDescriptionTypeInContents < ActiveRecord::Migration
  change_table :contents do |t|
    t.change :description, :text
  end
end
