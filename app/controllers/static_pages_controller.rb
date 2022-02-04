require 'httparty'
require 'Github'

class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: [:callback]
  before_action :code_param, only: [:callback]

  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def callback
    if params.has_key?(:code)
      github = Github.new
      new_token_response = github.new_access_token(params[:code])
      
      if new_token_response != 200
        flash[:danger] = "An error occurred authenticating your github account. Please try again."
        redirect_to root_url and return
      end
      
      github_user = github.user

      p github_user

      current_user.connect_to_github(github.access_token, github_user["login"])
      flash[:success] = "Github account connected!"

      redirect_to current_user
    else
      flash[:danger] = "Invalid code"
      redirect_to root_url
    end
  end

  private
    # Before filters
    
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms presence of code param
    def code_param
      unless params.has_key?(:code)
        flash[:danger] = "No code detected"
        redirect_to root_url
      end
    end
end
