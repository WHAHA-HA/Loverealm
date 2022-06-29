json.array! @suggested_users do |suggested_user|
  json.id suggested_user.id
  json.full_name suggested_user.full_name
  json.avatar_url suggested_user.avatar.url
end
