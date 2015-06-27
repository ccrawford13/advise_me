class Student < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email, unique: true
  validates_presence_of :year
  validates_presence_of :major

  def clean_error_messages
    stringify = self.errors.full_messages.to_s
    stringify.tr('[]', '')
  end

end
