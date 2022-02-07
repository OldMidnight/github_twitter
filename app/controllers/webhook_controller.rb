class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render :json => {:status => 200}
  end
end
