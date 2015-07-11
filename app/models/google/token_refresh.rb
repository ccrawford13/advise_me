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
      # divide new_expiration by 60 to get time till
      # expiration in minutes. Each new token should
      # be good for 60 min
      new_expiration = refresh_hash['expires_in'] / 60
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
    # treat token as expired if there is 1 min or less remaining
    # before expiration. this will be checked before every
    # call to the calendar API
    return true if @token_expiration.to_i <= 1
  end
end
