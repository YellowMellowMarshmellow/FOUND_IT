class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.references :claim, null: false, foreign_key: true
      t.references :found_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
