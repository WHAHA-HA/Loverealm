FactoryGirl.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    scopes 'full_access'
  end
end