class AddUserToLostItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :lost_items, :user, null: false, foreign_key: true
  end
end
