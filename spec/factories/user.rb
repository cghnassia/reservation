FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Staff"
    middle_name "Stewart"
    birthdate { 21.years.ago }
    email "johnstaff@example.com"
    avatar ""
    activated true
  end
end