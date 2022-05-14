class Prediction < ApplicationRecord

  belongs_to :match
  belongs_to :player


  validates :side, presence: true
  validates :match_id, uniqueness: { scope: :player_id }

end
