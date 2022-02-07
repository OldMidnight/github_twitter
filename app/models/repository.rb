class Repository < ApplicationRecord
  belongs_to :user, foreign_key: "owner_id"
  validates :owner_id, presence: true

  # Update hook_id.
  def update_webhook(hook_id)
    update_attribute(:hook_id, hook_id)
  end
end
