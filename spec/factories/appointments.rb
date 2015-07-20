require "faker"

FactoryGirl.define do
  factory :appointment do
    summary { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
  end
end
