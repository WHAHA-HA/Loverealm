class RemoveDuplicatesFromHashTags < ActiveRecord::Migration
  # def change
  #   # dup_names = HashTag.select('name').having('COUNT(*) > 1').group('name')
  #   #                    .pluck('name')

  #   # dup_names.each do |name|
  #   #   tags = HashTag.where(name: name)
  #   #   dup_tags = tags.drop(1)

      %w(contents_hash_tags hash_tags_users).each do |table_name|
        query = "UPDATE #{table_name} SET hash_tag_id = $1 WHERE hash_tag_id IN ($2)"
        ActiveRecord::Base.connection.exec_query(query, 'SQL', [
          [nil, tags.first.id],
          [nil, dup_tags.map(&:id).join(',')]
        ])
      end

  #   #   dup_tags.each &:destroy
  #   # end
  # end
end
