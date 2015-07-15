require "faker"

FactoryGirl.define do
  factory :student do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email("#{last_name}") }
    year { Faker::Lorem.words(1) }
    major { Faker::Lorem.words(2) }
    user
  end

end
