require "test_helper"

class RepositoryControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
end
