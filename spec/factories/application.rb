FactoryGirl.define do
  factory :application, class: Doorkeeper::Application do
    name "demo_application"
    redirect_uri "https://lvh.me:4000/auth/demo_application/callback"
  end
end