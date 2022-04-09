class AddReactionsCountToMatches < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :reactions_count, :integer, null: false, default: 0
  end
end
