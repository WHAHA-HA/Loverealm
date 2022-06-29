class AddTrigramIndexToContentDescription < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      CREATE INDEX contents_on_description_idx on contents USING gin(description gin_trgm_ops);
    SQL
  end

  def self.down
    execute <<-SQL
    DROP INDEX contents_on_description_idx ;
    SQL
  end
end
