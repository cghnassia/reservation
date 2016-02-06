RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Staff"
    email "johnstaff@example.com"
    
  end