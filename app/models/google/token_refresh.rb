require 'rest-client'
class TokenRefresh

  def initialize(auth_token, refresh_token, token_expiration)
    @auth_token = auth_token
    @refresh_token = refresh_token
    @token_expiration = token_expiration
  end

  def validate_token_auth
    if expired_token?
      # if the token is expired make a post call to google with the
      # refresh_token to recieve a new short term auth_token(60 min)
      response = RestClient.post "https://www.googleapis.com/oauth2/v3/token",
                                  client_id: ENV["GOOGLE_CLIENT_ID"],
                                  client_secret: ENV["GOOGLE_CLIENT_SECRET"],
                                  refresh_token: @refresh_token,
                                  grant_type: 'refresh_token'
      refresh_hash = JSON.parse(response.body)
      new_token = refresh_hash['access_token']
      # expires_in returns a numeric value eql to 60 min
      # we will call the create_expiration_time method
      # to add the 60 min to the current time
      new_expiration = create_expiration_time(refresh_hash['expires_in'].to_i)
      # used explicit return statement to clarify
      # what values are being returned & why
      return new_token, new_expiration
      # return new values for token and expiration
      # if token was expired and updated with new value
    else
      return @auth_token, @token_expiration
      # if the token was not expired, return
      # the original values to be rechecked at next call
    end
  end

  def expired_token?
    # token is expired if the expiration time saved
    # is before or eql to the current time
    # this will be checked before ever call to the calendar API
    return true if @token_expiration.to_i <= Time.now.to_i
  end

  def create_expiration_time(time)
    # subtract 5 minutes from expiration time as buffer so
    # user will not run into invalid token errors
    # ideally the validation of tokens and API calls could be automated
    # to refresh every minute or so
    (Time.now.to_i + (time - 300))
  end
end
