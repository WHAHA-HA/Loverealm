json.array!(@likes) do |like|
  json.extract! like, :id, :user_id, :story_id, :post_status_id
  json.url like_url(like, format: :json)
end
