json.array! @contents do |content|
  json.partial! 'api/v1/pub/contents/content', content: content
end
