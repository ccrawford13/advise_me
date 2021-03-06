require "faker"

FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    position "Advisor"
    organization { Faker::Company.name }
    email { Faker::Internet.email("#{last_name}") }
    password { Faker::Internet.password }
  end

end
