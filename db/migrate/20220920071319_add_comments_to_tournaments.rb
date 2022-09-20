class AddCommentsToTournaments < ActiveRecord::Migration[6.1]

  def change
    add_column :tournaments, :reactions_count, :integer, null: false, default: 0
    add_column :tournaments, :comments_count, :integer, null: false, default: 0
  end

end
