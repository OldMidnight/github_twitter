class CreateRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :repositories do |t|
      t.integer :repository_id
      t.string :name
      t.string :hook_id
      t.integer :owner_id

      t.timestamps
    end
  end
end
