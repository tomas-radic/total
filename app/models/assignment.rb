class Assignment < ApplicationRecord

  # Relations -----
  belongs_to :player
  belongs_to :match


  # Validations -----
  validates :player_id, uniqueness: { scope: :match_id }

end
