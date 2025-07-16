class CreateLostItems < ActiveRecord::Migration[7.1]
  def change
    create_table :lost_items do |t|
      t.string :title
      t.text :description
      t.string :category
      t.string :location
      t.date :date_lost
      t.string :contact
      t.string :image

      t.timestamps
    end
  end
end
