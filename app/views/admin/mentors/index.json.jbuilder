json.array!(@admin_mentors) do |admin_mentor|
  json.extract! admin_mentor, :id
  json.url admin_mentor_url(admin_mentor, format: :json)
end
