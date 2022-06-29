json.id comment.id
json.body comment.body
json.created_at comment.created_at.to_i
json.updated_at comment.updated_at.to_i

json.user do
  json.partial! 'api/v1/pub/users/simple_user', user: comment.user
end
