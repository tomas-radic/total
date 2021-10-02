class Enrollment < ApplicationRecord

  # Relations -----
  belongs_to :player
  belongs_to :season


  # Validations -----
  validates :player_id, uniqueness: { scope: :season_id }

end
