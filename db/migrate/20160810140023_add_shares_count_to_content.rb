class AddSharesCountToContent < ActiveRecord::Migration
  def change
    add_column :contents, :shares_count, :integer, default: 0
  end
end
