require "faker"

FactoryGirl.define do
  factory :note do
    body { Faker::Lorem.paragraph }
    date { Faker::Date.between(10.days.ago, Date.today) }
    student
  end
  
end
