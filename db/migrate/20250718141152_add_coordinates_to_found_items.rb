class AddCoordinatesToFoundItems < ActiveRecord::Migration[7.1]
  def change
    add_column :found_items, :latitude, :float
    add_column :found_items, :longitude, :float
  end
end
