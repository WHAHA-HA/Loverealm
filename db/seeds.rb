# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

%w(banned users moderator admin).each do |role|
  Role.find_or_create_by(name: role)
  p "#{role} has been created"
end
%w(#Jealousy #Love #Relationships #Prayer #Jesus).each do |hash_tag|
  h = HashTag.new
  h.name = hash_tag
  p "HashTag #{hash_tag} has been created" if h.save
end
