class CreateThankYouNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :thank_you_notes do |t|
      t.text :message
      t.references :recipient, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
