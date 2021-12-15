class AddIsOpenToPlayToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :open_to_play_since, :datetime
  end
end
