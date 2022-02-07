class AddWebhookIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :webhook_id, :string
  end
end
