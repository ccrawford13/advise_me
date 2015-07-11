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
    # grab the expires_at value from access_token & convert it to time
    # remaining in minutes -> this way all methods that deal with
    # token_expiration will be looking for a time in minutes instead of a date
    expiration_in_min = token_expiration_in_min(access_token["credentials"]["expires_at"])
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
                           refresh_token: access_token["credentials"]["refresh_token"],
                           token_expiration: expiration_in_min,
                           provider: access_token["provider"]

        )
    end
    user.save!
    user
  end

  # Convert expires_at date from omniauth to
  # number of minutes remaining before token expires
  def self.token_expiration_in_min(expiration_date)
    (expiration_date.to_i - Time.now.to_i) / 60
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
    unless new_token != self.auth_token && new_expiration != self.token_expiration
      self.update_attributes(auth_token: new_token, token_expiration: new_expiration)
    end
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def student_count
    students.count
  end
end
