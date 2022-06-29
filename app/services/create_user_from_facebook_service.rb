class CreateUserFromFacebookService
  def call(access_token)
    facebook_uri = URI.parse("https://graph.facebook.com/v2.7/me?access_token=#{access_token}&fields=id,name,email,first_name,last_name")
    response = Net::HTTP.get_response(facebook_uri)
    
    if response.code == '200'
      facebook_user = JSON.parse(response.body)
    
      auth_params = OmniAuth::AuthHash.new({
        provider: 'facebook',
        uid: facebook_user['id'],
        info: {
          first_name: facebook_user['first_name'],
          last_name: facebook_user['last_name'],
          name: facebook_user['name'],
          email: facebook_user['email']
        },
        credentials: {
          token: access_token
        }
      })
    
      User.create_from_omniauth(auth_params)
    else
      nil
    end
  end
end