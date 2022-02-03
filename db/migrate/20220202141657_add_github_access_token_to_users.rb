class AddGithubAccessTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :github_access_token, :string
  end
end
