FactoryGirl.define do
  factory :comment do
    user
    association :content, factory: :status
    body { Faker::Lorem.sentence }
  end
end
