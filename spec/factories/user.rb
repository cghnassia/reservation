require 'faker'

FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name {Faker::Name.last_name }
    middle_name { Faker::Name.first_name }
    birthdate { Faker::Date.between(100.years.ago, Date.today) }
    email { Faker::Internet.email }
    avatar { Faker::Avatar.image }
    activated true
  end
end