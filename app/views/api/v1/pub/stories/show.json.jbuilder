json.partial! 'api/v1/pub/contents/content', content: @story

json.comments @story.comments do |comment|
  json.partial! 'api/v1/pub/comments/comment', comment: comment
end
