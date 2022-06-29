FactoryGirl.define do
  factory :doorkeeper_access_token, class: Doorkeeper::AccessToken do
    scopes 'full_access'
  end
end
