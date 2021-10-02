class CreateEnrollments < ActiveRecord::Migration[6.1]
  def change
    create_table :enrollments, id: :uuid do |t|
      t.references :player, null: false, foreign_key: { unique: :season_id }, type: :uuid
      t.references :season, null: false, foreign_key: true, type: :uuid
      t.datetime :canceled_at

      t.timestamps
    end
  end
end
