class CreateClaims < ActiveRecord::Migration[7.1]
  def change
    create_table :claims do |t|
      t.references :user, null: false, foreign_key: true
      t.text :message
      t.string :category
      t.text :description
      t.string :title
      t.string :locations
      t.date :date_reported

      t.timestamps
    end
  end
end
