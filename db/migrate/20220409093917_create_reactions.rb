class CreateReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :reactions, id: :uuid do |t|
      t.references :player, null: false, foreign_key: true, type: :uuid
      t.references :reactionable, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
