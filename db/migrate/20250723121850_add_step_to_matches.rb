class AddStepToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :step, :integer
  end
end
