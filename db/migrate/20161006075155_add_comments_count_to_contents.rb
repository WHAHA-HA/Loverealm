class AddCommentsCountToContents < ActiveRecord::Migration
  def change
    # add_column :contents, :comments_count, :integer, default: 0

    reversible do |dir|
      dir.up do
        execute <<-SQL.squish
            UPDATE contents
               SET comments_count = (SELECT count(*)
                                       FROM comments
                                      WHERE comments.content_id = contents.id)
        SQL
      end
    end
  end
end
