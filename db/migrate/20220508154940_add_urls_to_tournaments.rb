class AddUrlsToTournaments < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :draw_url, :string
    add_column :tournaments, :schedule_url, :string
  end
end
