class AddTokenToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :oauth_token, :string
  end
end
