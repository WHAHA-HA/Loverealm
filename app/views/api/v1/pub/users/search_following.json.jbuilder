json.array! @users do |user|
  json.partial! 'api/v1/pub/users/simple_user', user: user
end