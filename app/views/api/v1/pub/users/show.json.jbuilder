json.id @user.id
json.email @user.email
json.first_name @user.first_name
json.last_name @user.last_name
json.nick @user.nick
json.birthdate (@user.birthdate.present? ? @user.birthdate.to_time.to_i : nil)
json.sex @user.sex
json.biography @user.biography
json.country @user.country
json.location @user.location
json.avatar_url @user.avatar.url
json.cover_photo_url @user.cover.url
json.created_at @user.created_at.to_i
json.updated_at @user.updated_at.to_i
json.is_newbie @user.is_newbie
json.phone_number @user.phone_number
