json.id content.id
json.description content.description
json.number_of_likes content.votes_for.count
json.number_of_comments content.comments_count
json.type content.content_type

if content.is_picture?
  json.image_url content.image.url
elsif content.is_story? || content.is_daily_story?
  json.image_url content.image.url
  json.title content.title
end

json.created_at content.created_at.to_i
json.updated_at content.updated_at.to_i

json.hash_tags content.hash_tags do |hash_tag|
  json.id hash_tag.id
  json.name hash_tag.name
end

json.user do
  json.partial! 'api/v1/pub/users/simple_user', user: content.user
end

json.liked content.is_liked_by?(current_user)
json._link dashboard_content_path(content)
