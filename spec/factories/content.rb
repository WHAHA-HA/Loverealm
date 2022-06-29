FactoryGirl.define do
  factory :status, class: Content do
    description { Faker::Lorem.sentence }
    content_type 'status'
  end

  factory :picture, class: Content do
    description { Faker::Lorem.sentence }
    content_type 'image'
    image { File.new(Rails.root.join('spec', 'support', 'fixtures', 'rails.png')) }
  end

  factory :story, class: Content do
    description { Faker::Lorem.sentence }
    content_type 'story'
    image { File.new(Rails.root.join('spec', 'support', 'fixtures', 'rails.png')) }
    title { Faker::Lorem.sentence }
  end
end
