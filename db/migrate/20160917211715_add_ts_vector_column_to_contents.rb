class AddTsVectorColumnToContents < ActiveRecord::Migration
  def up
    add_column :contents, :tsv, :tsvector
    add_index :contents, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON contents FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', description, title
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE contents SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON contents
    SQL

    remove_index :contents, :tsv
    remove_column :contents, :tsv
  end
end
