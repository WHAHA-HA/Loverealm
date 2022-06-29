json.partial! 'api/v1/pub/contents/content', content: @status

json.comments @status.comments do |comment|
  json.partial! 'api/v1/pub/comments/comment', comment: comment
end
