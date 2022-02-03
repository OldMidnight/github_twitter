require 'httparty'

class Github
  include HTTParty
  format :json

  base_uri 'https://api.github.com'

  def initialize
  end

  def headers
    { 
      Authorization: "token #{@access_token}",
      Accept: "application/vnd.github.v3+json"
    }
  end

  def user
    params = { headers: headers }
    user = self.class.get('/user', params)
    JSON.parse(user.body)
  end

  def new_access_token(code)
    response = self.class.post('https://github.com/login/oauth/access_token',
      { 
        body: {
          client_id: ENV['GITHUB_CLIENT_ID'],
          client_secret: ENV['GITHUB_CLIENT_SECRET'],
          code: code
        },
        headers: { Accept: 'application/json' }
      })

    if response.code == 200
      set_access_token(JSON.parse(response.body)['access_token'])
    end

    response.code
  end

  def set_access_token(token)
    @access_token = token
  end

  def access_token
    @access_token
  end
end