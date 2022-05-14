class CreatePredictions < ActiveRecord::Migration[6.1]
  def change
    create_table :predictions, id: :uuid do |t|
      t.references :match, null: false, foreign_key: true, type: :uuid
      t.references :player, null: false, foreign_key: true, type: :uuid
      t.integer :side, null: false

      t.timestamps

      t.index [:match_id, :player_id], unique: true
    end
  end
end
