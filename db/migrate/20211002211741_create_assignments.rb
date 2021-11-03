class CreateAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :assignments, id: :uuid do |t|
      t.references :player, null: false, foreign_key: { unique: :match }, type: :uuid
      t.references :match, null: false, foreign_key: true, type: :uuid
      t.integer :side, null: false
      t.boolean :is_retired, null: false, default: false

      t.timestamps
    end
  end
end
