class CreateTournaments < ActiveRecord::Migration[6.1]
  def change
    create_table :tournaments, id: :uuid do |t|
      t.string :name, null: false
      t.date :begin_date
      t.date :end_date
      t.string :main_info, null: false
      t.text :side_info
      t.integer :color_base, null: false
      t.datetime :published_at
      t.references :season, null: false, foreign_key: true, type: :uuid
      t.references :place, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
