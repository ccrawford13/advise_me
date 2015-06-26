class User < ActiveRecord::Base
  has_many :students

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :position
  validates_presence_of :organization

  def full_name
    [first_name, last_name].join(" ")
  end
end
