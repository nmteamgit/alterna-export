FactoryGirl.define do
  factory :admin do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password 'password'
    password_confirmation 'password'
    role_id Role.first.id
  end
end
