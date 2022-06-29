json.array!(@admin_words) do |admin_word|
  json.extract! admin_word, :id, :name
  json.url admin_word_url(admin_word, format: :json)
end
