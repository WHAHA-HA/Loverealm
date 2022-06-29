include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'loverealm'
    password_confirmation 'loverealm'
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    avatar_file_name { 'avatar' }
    is_newbie { false }
    biography { Faker::Lorem.sentence }
    confirmed_at Date.today
    notifications_checked_at Date.today
  end

  factory :user_with_content, class: User do
    email { Faker::Internet.email }
    password 'loverealm'
    password_confirmation 'loverealm'
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    avatar_file_name { 'avatar' }
    is_newbie { false }
    biography { Faker::Lorem.sentence }
    confirmed_at Date.today

    after(:create) do |user|
      user.contents << create(:status)
    end
  end

  factory :newbie_user, class: User do
    email { Faker::Internet.email }
    password 'loverealm'
    password_confirmation 'loverealm'
    confirmed_at Date.today
    is_newbie { true }
  end

  factory :admin, class: User do
    email { Faker::Internet.email }
    password 'loverealm'
    password_confirmation 'loverealm'
    confirmed_at Date.today
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    biography { Faker::Lorem.sentence }
    after(:create) do |user|
      user.role = create(:admin_role)
      user.save
    end
  end

  factory :admin_role, class: Role do
    name 'admin'
  end
end
