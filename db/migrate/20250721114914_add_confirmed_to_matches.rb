class AddConfirmedToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :confirmed, :boolean
  end
end
