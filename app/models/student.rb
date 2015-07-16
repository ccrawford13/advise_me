class Student < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :year, presence: true
  validates :major, presence: true

  def self.import(user_id, file)
    CSV.foreach(file.path, headers: true) do |row|
      student_values = row.to_hash.delete_if { |k, v| v == nil }
      student_values.store("user_id", "#{user_id}")
      student = Student.where(email: student_values["email"]).first
      if student
        student.update_attributes(student_values)
      else
        if student_values.length > 1
          Student.create!(student_values).valid?
        else
          false
        end
      end
    end
  end
end
