class AddTypeToContent < ActiveRecord::Migration
  def change
    add_column :contents, :content_type, :string
  end
end
