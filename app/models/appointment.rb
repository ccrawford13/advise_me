class Appointment < ActiveRecord::Base
  belongs_to :user

  validates :summary, presence: true
  validates :description, presence: true
end
