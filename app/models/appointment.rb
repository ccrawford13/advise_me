class Appointment < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :summary
  validates_presence_of :description
end
