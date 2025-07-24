class AddCoordinatesToLostItems < ActiveRecord::Migration[7.1]
  def change
    add_column :lost_items, :latitude, :float
    add_column :lost_items, :longitude, :float
  end
end
