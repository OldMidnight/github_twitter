require 'httparty'
require 'json'

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
            url: "#{ENV['APP_URL']}/hooks",
            content_type: "json",
            secret: ENV['WEBHOOK_SECRET']
          },
          events: ['pull_request', 'push']
        }.to_json,
        headers: headers
      })
  end

  def handle_push(data)
    github_username = data["repository"]["owner"]["login"]
    @user = User.find_by(github_username: github_username)
    @repository = Repository.find_by(repository_id: data["repository"]["id"])
    commits = data["commits"].map {|commit| "#{commit['message']} - #{commit['timestamp']}\n"}

    content = "
    Heyo! I just made a push to #{@repository.name} with the following commit(s):\n
    #{commits}\n
    Let me know what you think!
    "
    @micropost = @user.microposts.build({
      content: content
    })

    @micropost.save!
  end
  handle_asynchronously :handle_push
end