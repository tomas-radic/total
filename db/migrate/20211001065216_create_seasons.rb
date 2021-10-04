class CreateSeasons < ActiveRecord::Migration[6.1]
  def change
    create_table :seasons, id: :uuid do |t|
      t.string :name, null: false
      t.integer :play_off_size, null: false, default: 8
      t.integer :points_single_20, null: false
      t.integer :points_single_21, null: false
      t.integer :points_single_12, null: false
      t.integer :points_single_02, null: false
      t.integer :points_double_20, null: false
      t.integer :points_double_21, null: false
      t.integer :points_double_12, null: false
      t.integer :points_double_02, null: false
      t.datetime :ended_at

      t.timestamps
    end
  end
end
