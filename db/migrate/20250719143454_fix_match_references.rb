class FixMatchReferences < ActiveRecord::Migration[7.1]
  def change
    # Remove colunas erradas (se existirem)
    remove_column :matches, :lost_items_id, :bigint
    remove_column :matches, :found_items_id, :bigint

    # Adiciona referências corretas
    add_reference :matches, :lost_item, foreign_key: true
    add_reference :matches, :found_item, foreign_key: true
  end
end
