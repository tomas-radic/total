class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches, id: :uuid do |t|
      t.date :play_date
      t.integer :play_time
      t.string :notes
      t.integer :kind, null: false, default: 0
      t.integer :winner_side
      t.integer :retired_side
      t.datetime :finished_at
      t.boolean :play_off_counted, null: false, default: true
      t.references :competitable, polymorphic: true, null: false, type: :uuid
      t.integer :set1_side1_score
      t.integer :set1_side2_score
      t.integer :set2_side1_score
      t.integer :set2_side2_score
      t.integer :set3_side1_score
      t.integer :set3_side2_score

      t.timestamps
    end
  end
end
