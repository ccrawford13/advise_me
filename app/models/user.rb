class User < ActiveRecord::Base
  has_many :students

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:google_oauth2]

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :position
  validates_presence_of :organization

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
        user = User.create(first_name: data["name"],
                           last_name: data["name"],
                           position: "Advisor",
                           organization: "Organization",
                           email: data["email"],
                           password: Devise.friendly_token[0,20],
                           confirmed_at: Time.now,
                           uid: access_token["uid"],
                           auth_token: access_token["credentials"]["token"],
                           provider: access_token["provider"]
        )
    end
    user
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def student_count
    students.count
  end
end
