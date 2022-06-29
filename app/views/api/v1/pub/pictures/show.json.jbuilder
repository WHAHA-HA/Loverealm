json.partial! 'api/v1/pub/contents/content', content: @picture

json.comments @picture.comments do |comment|
  json.partial! 'api/v1/pub/comments/comment', comment: comment
end
