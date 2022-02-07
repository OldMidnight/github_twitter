require "test_helper"
require 'github'

class GithubConnectionTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @github = Minitest::Mock.new
    def @github.user() { login: "michael" } end
    def @github.new_access_token(code) 200 end
    def @github.access_token() '1234' end
    def @github.repositories(username) { test: 1 } end
  end

  test "connect to github and update user access_token" do
    Github.stub :new, @github do
      gh = Github.new
      log_in_as(@user)
      get callback_path, params: { code: 1234 }
      assert @user.reload.github_connected?
      assert_equal @user.github_username, "michael"
      assert_redirected_to @user
      follow_redirect!
      assert_template 'users/show'
      assert_select "a[href=?]", "https://github.com/#{@user.github_username}"
    end
  end

  test "redirect on invalid github authentiction" do
    def @github.new_access_token(code) 401 end
    Github.stub :new, @github do
      log_in_as(@user)
      get callback_path, params: { code: 1234 }
      assert_not flash.empty?
      assert_redirected_to root_url
    end
  end

  test "redirect on missing code param" do
    log_in_as(@user)
    get callback_path
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
