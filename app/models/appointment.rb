class Appointment < ActiveRecord::Base
  serialize :attendees
  belongs_to :user
end
