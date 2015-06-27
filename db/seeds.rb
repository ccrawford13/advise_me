require 'faker'
# Admin
director = User.new(
  first_name:             'Bill',
  last_name:              'Director',
  position:               'Director',
  organization:           'UWL',
  email:                  'director.bill@example.com',
  password:               'password',
  password_confirmation:  'password'
)
director.skip_confirmation!
director.save!
# Advisors
5.times do
  advisor = User.new(
    first_name:             Faker::Name.first_name,
    last_name:              Faker::Name.last_name,
    position:               'Advisor',
    organization:           'UWL',
    email:                  Faker::Internet.email,
    password:               'password',
    password_confirmation:  'password'
  )
  advisor.skip_confirmation!
  advisor.save!
end

users = User.all

# Students
50.times do
  student = Student.new(
    first_name:             Faker::Name.first_name,
    last_name:              Faker::Name.last_name,
    email:                  Faker::Internet.email,
    year:                   Faker::Lorem.words(1),
    major:                  Faker::Lorem.words(2),
    user:                   users.sample
  )
  student.save!
end

puts "Created #{director.first_name} with email: #{director.email}"
puts "Created #{(User.count)-1} Advisors"
puts "Created #{Student.count} Students"
