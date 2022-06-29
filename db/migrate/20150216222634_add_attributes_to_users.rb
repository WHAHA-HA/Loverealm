class AddAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :location, :string
    add_column :users, :biography, :text
    add_column :users, :sex, :integer
    add_column :users, :country, :string
    add_column :users, :birthdate, :date
  end
end
