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
      flash[:danger] = "An error occurred authenticating your github account. Please try again."
      redirect_to root_url and return
    end

    result = JSON.parse(response.body)
    @repository.update_webhook(result["id"])
    flash[:success] = "Github account connected!"

    redirect_to repositories_user_path
  end

  def edit
  end

  def update
  end
end
