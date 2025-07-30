class AddReviewToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :review, :text
  end
end
