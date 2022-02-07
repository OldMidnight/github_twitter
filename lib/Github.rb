require 'httparty'

class Github
  include HTTParty
  format :json

  base_uri 'https://api.github.com'

  def initialize
    @access_token = nil
  end

  def headers
    { 
      Authorization: "token #{@access_token}",
      Accept: "application/vnd.github.v3+json"
    }
  end

  def user
    user = self.class.get('/user', { headers: headers })
    JSON.parse(user.body)
  end

  def repositories(github_username)
    response = self.class.get("/users/#{github_username}/repos", { headers: headers })
    JSON.parse(response.body)
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

  def subscribe_to_repo(repo_name)
    self.class.post("/repos/#{repo_name}/hooks",
      { 
        body: {
          config: {
            url: "#{ENV[APP_URL]}/hooks",
            content_type: 'json',
            secret: ENV['WEBHOOK_SECRET']
          },
          events: ['pull_request', 'push']
        },
        headers: headers
        })
  end
end