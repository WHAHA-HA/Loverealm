class HashTag < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :contents

  has_many :mentorships
  has_many :mentors, class_name: 'User', through: :mentorships

  def self.trending_tags
    content_query = select('hash_tags.id, count(*) as weight')
                    .joins(:contents).group('hash_tags.id').to_sql

    select('hash_tags.*, SUM(trending_tags.weight) as total_weight')
      .from("(#{content_query}) AS trending_tags")
      .joins('INNER JOIN hash_tags ON hash_tags.id = trending_tags.id')
      .group('hash_tags.id').order('total_weight DESC')
  end
end
