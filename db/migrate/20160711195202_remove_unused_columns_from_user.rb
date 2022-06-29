class RemoveUnusedColumnsFromUser < ActiveRecord::Migration
  def up 
    remove_index 'users', name: 'index_users_on_identity'
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
    remove_column :users, :oauth_token, :string
  end

  def down
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :oauth_token, :string
    add_index 'users', %w(email provider uid), name: 'index_users_on_identity', unique: true
  end
end