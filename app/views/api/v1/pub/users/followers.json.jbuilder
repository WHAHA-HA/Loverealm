json.count @count
json.users @users do |user|
  json.partial! 'api/v1/pub/users/simple_user', user: user
  json.following current_user.following?(user)
end