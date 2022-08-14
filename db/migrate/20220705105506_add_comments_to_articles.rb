class AddCommentsToArticles < ActiveRecord::Migration[6.1]

  def change
    add_column :articles, :reactions_count, :integer, null: false, default: 0
    add_column :articles, :comments_count, :integer, null: false, default: 0
    add_column :articles, :comments_disabled_since, :datetime
  end

end
