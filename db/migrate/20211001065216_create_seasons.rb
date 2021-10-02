class CreateSeasons < ActiveRecord::Migration[6.1]
  def change
    create_table :seasons, id: :uuid do |t|
      t.string :name, null: false
      t.datetime :ended_at

      t.timestamps
    end
  end
end
