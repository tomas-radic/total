class Prediction < ApplicationRecord

  belongs_to :match
  belongs_to :player


  validates :side, presence: true, inclusion: { in: [1, 2] }
  validates :match_id, uniqueness: { scope: :player_id }

end
