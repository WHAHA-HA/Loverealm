FactoryGirl.define do
  factory :status_report, class: Report do
    user
    association :target, factory: :status
    description { Faker::Lorem.sentence }
    reviewed false
  end

  factory :comment_report, class: Report do
    user
    association :target, factory: :comment
    description { Faker::Lorem.sentence }
    reviewed false
  end

  factory :user_report, class: Report do
    user
    association :target, factory: :user
    description { Faker::Lorem.sentence }
    reviewed false
  end
end
