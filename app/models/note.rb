class Note < ActiveRecord::Base
  belongs_to :student

  validates :date, presence: true
  validates :body, presence: true
end
