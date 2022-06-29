module Taggable
  # https://github.com/ralovely/simple_hashtag/blob/master/lib/simple_hashtag/hashtag.rb
  HASHTAG_REGEX = /(?:\s|^)(#(?!(?:\d+|\w+?_|_\w+?)(?:\s|$))([a-z0-9\-_]+))/i

  def find_hash_tags
    extract_hash_tags.map do |tag|
      HashTag.find_or_create_by(name: tag[0])
    end
  end

  private

  def extract_hash_tags
    return [] unless description =~ /[#]/

    match = description.scan(Taggable::HASHTAG_REGEX)
    match.uniq!
    match
  end
end
