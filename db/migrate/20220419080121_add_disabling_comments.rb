class AddDisablingComments < ActiveRecord::Migration[6.1]

  def change
    add_column :players, :comments_disabled_since, :datetime
    add_column :matches, :comments_disabled_since, :datetime
    add_column :tournaments, :comments_disabled_since, :datetime
  end

end
