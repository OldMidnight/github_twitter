class RepositoriesController < ApplicationController
  def index
  end

  def create
    @user = current_user
    @repository = Repository.find(params[:repository_id])
    github = Github.new

    github.set_access_token(@user.github_access_token)
    
    response = github.subscribe_to_repo(params[:repository_name])

    if response.code != 201
      result = JSON.parse(response.body)
      flash[:danger] = "Github API Error: " + result["message"]
      redirect_to root_url and return
    end

    result = JSON.parse(response.body)
    @repository.update_webhook(result["id"])
    flash[:success] = "Repository subscribed!"

    redirect_to repositories_user_path @user.id
  end

  def edit
  end

  def update
  end
end
