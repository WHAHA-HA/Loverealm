json.users @result[:users] do |user|
  json.partial! 'api/v1/pub/users/simple_user', user: user
end
json.contents @result[:contents] do |content|
  json.partial! 'api/v1/pub/contents/content', content: content
end
