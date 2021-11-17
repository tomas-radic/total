class Player < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable


  # Relations -----
  has_many :enrollments, dependent: :destroy
  has_many :seasons, through: :enrollments
  has_many :assignments, dependent: :destroy
  has_many :matches, through: :assignments

  # Validations -----
  validates :phone_nr, uniqueness: true
  validates :name,
            presence: true, uniqueness: true


  def won_matches(season = nil)
    if season.present?
      season.matches.reviewed.joins(:assignments)
            .where("assignments.player_id = ?", id)
            .where("assignments.side = matches.winner_side").distinct
    else
      self.matches.reviewed.joins(:assignments)
          .where("assignments.player_id = ?", id)
          .where("assignments.side = matches.winner_side").distinct
    end
  end
end
