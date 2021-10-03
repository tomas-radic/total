class Enrollment < ApplicationRecord

  # Relations -----
  belongs_to :player
  belongs_to :season


  # Validations -----
  validates :player_id, uniqueness: { scope: :season_id }


  # Scopes -----
  scope :active, -> { where(canceled_at: nil) }
end
