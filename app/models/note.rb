class Note < ActiveRecord::Base
  belongs_to :student

  validates :date, presence: true
  validates :body, presence: true

  MONTH = "%B"
  DATE = "%d"
  DAY = "%A"

  def month
    date.strftime(MONTH)
  end

  def date_num
    date.strftime(DATE)
  end

  def day
    date.strftime(DAY)
  end

end
