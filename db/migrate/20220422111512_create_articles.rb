class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles, id: :uuid do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.string :link
      t.date :promote_until
      t.references :manager, null: false, foreign_key: true, type: :uuid
      t.references :season, null: false, foreign_key: true, type: :uuid
      t.integer :color_base, null: false
      t.datetime :published_at

      t.timestamps
    end
  end
end
