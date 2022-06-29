class CreateUserFromGoogleService
  def call(access_token)
    google_uri = URI.parse("https://www.googleapis.com/plus/v1/people/me?access_token=#{access_token}")
    response = Net::HTTP.get_response(google_uri)
    
    if response.code == '200'
      google_user = JSON.parse(response.body)

      auth_params = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: google_user['id'],
        info: {
          first_name: google_user['name']['givenName'],
          last_name: google_user['name']['familyName'],
          name: google_user['display_name'],
          email: get_account_email(google_user['emails'])
        },
        credentials: {
          token: access_token
        }
      })

      # TODO: Handle situation where user object is returned but not saved to database (bacause of validation errors)
      User.create_from_omniauth(auth_params)      
    else
      nil
    end
  end

  private
  def get_account_email(emails_hash)
    account_email = emails_hash.find do |email|
      email['type'] == 'account'
    end

    account_email["value"]
  end
end