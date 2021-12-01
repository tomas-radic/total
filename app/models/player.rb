class Player < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :recoverable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :trackable


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


  def opponents(season: nil, pending: false, ranking_counted: false)
    player_matches = matches
    player_matches = player_matches.pending if pending
    player_matches = player_matches.ranking_counted if ranking_counted
    player_matches = player_matches.joins(:assignments).where("assignments.player_id = ?", id)

    match_ids = []

    if season.nil?
      match_ids = player_matches.map(&:id)
    else
      player_matches.each do |m|
        case m.competitable_type
        when "Season"
          match_ids << m.id if m.competitable_id == season.id
        when "Tournament"
          match_ids << m.id if m.competitable.season_id == season.id
        end
      end
    end

    Player.joins(:assignments)
          .where("assignments.match_id in (?)", match_ids)
          .where.not(id: id)
  end


  def anonymize!
    ActiveRecord::Base.transaction do
      matches.where(finished_at: nil).destroy_all

      update!(
        anonymized_at: Time.now,
        email: "#{SecureRandom.hex}@anonymized.player",
        name: "(zmazaný hráč)",
        phone_nr: nil,
        birth_year: nil
      )
    end

    self
  end
end
