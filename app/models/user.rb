class User < ActiveRecord::Base
  has_many :students
  has_many :appointments
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:google_oauth2]

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :position, presence: true
  validates :organization, presence: true

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first
    unless user
        user = User.create(first_name: data["first_name"] || data["email"],
                           last_name: data["last_name"] || data["email"],
                           position: "Advisor",
                           organization: "Organization",
                           email: data["email"],
                           password: Devise.friendly_token[0,20],
                           confirmed_at: Time.now,
                           uid: access_token["uid"],
                           auth_token: access_token["credentials"]["token"],
                           refresh_token: access_token["credentials"]["refresh_token"],
                           token_expiration: access_token["credentials"]["expires_at"].to_i,
                           provider: access_token["provider"]

        )
    end
    user.save!
    user
  end

  def check_auth_token
    refresh = TokenRefresh.new(self.auth_token,
                               self.refresh_token,
                               self.token_expiration
                              )
    # set refreshed_token & refreshed_expiration eql to
    # the return values of refresh.validate_token_auth
    refreshed_token, refreshed_expiration = refresh.validate_token_auth
    update_token(refreshed_token, refreshed_expiration)
  end

  def update_token(new_token, new_expiration)
    # if token & expiration passed in differ from those previously saved
    # update the user with the new values
    if new_token != self.auth_token && new_expiration != self.token_expiration
      self.update_attributes(auth_token: new_token, token_expiration: new_expiration)
      self.save!
    end
  end

  def student_sort(sort_query)
    students.order(sort_query)
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def student_count
    students.count
  end
end
