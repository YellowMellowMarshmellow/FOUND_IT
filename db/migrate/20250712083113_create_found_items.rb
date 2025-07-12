class CreateFoundItems < ActiveRecord::Migration[7.1]
  def change
    create_table :found_items do |t|
      t.string :title
      t.text :description
      t.string :location
      t.string :category
      t.date :date_reported
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
