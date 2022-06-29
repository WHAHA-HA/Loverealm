json.id @user.id
json.email @user.email
json.first_name @user.first_name
json.last_name @user.last_name
json.nick @user.nick
json.birthdate @user.birthdate.try(:to_i)
json.sex @user.sex
json.biography @user.biography
json.country @user.country
json.location @user.location
json.avatar_url @user.avatar.url
json.cover_photo_url @user.cover.url
json.created_at @user.created_at.to_i
json.updated_at @user.updated_at.to_i
json.following current_user.following?(@user)
json.number_of_followers @user.num_of_followers
json.number_of_followings @user.following.count
json.number_of_posts @user.contents.count

json.contents @contents do |content|
  json.partial! 'api/v1/pub/contents/content', content: content
end
