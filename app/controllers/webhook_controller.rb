require 'github'

class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    if params.has_key? "zen"
      head(:ok) and return
    end

    github = Github.new
    github.handle_push(params)
    
    # github_username = params["repository"]["owner"]["login"]
    # @user = User.find_by(github_username: github_username)
    # @repository = Repository.find_by(repository_id: params["repository"]["id"])
    # commits = params["commits"].map {|commit| "#{commit['message']} - #{commit['timestamp']}\n"}

    # content = "
    # Heyo! I just made a push to #{@repository.name} with the following commit(s):\n
    # #{commits}\n
    # Let me know what you think!
    # "
    # @micropost = @user.microposts.build({
    #   content: content
    # })

    head(:ok) and return
  end
end
