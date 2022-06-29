if @type == 'users'
  json.array! @result do |item|
    json.partial! 'api/v1/pub/users/simple_user', user: item
  end
elsif @type == 'contents'
  json.array! @result do |item|
    json.partial! 'api/v1/pub/contents/content', content: item
  end
end

