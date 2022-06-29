json.array!(@hash_tags) do |hash_tag|
  json.extract! hash_tag, :id, :name
  json.url hash_tag_url(hash_tag, format: :json)
end
