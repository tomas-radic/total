class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments, id: :uuid do |t|
      t.references :commentable, polymorphic: true, null: false, type: :uuid
      t.references :player, null: false, foreign_key: true, type: :uuid
      t.string :content, null: false
      t.integer :position
      t.references :motive, type: :uuid, index: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
