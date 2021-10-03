class Match < ApplicationRecord

  before_validation :set_defaults


  # Relations -----
  belongs_to :competitable, polymorphic: true
  has_many :assignments, dependent: :destroy
  has_many :players, through: :assignments


  # Validations -----
  validates :kind, presence: true
  validates :winner_side, inclusion: { in: [1, 2] }, if: Proc.new { |m| m.finished_at.present? }
  validate :player_assignments


  # Enums -----
  enum kind: {
    single: 0,
    double: 1
  }

  enum play_time: [
    "6:00", "6:30", "7:00", "7:30", "8:00", "8:30", "9:00", "9:30", "10:00", "10:30",
    "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30",
    "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30",
    "21:00", "21:30", "22:00"
  ]


  # Scopes
  scope :published, -> { where.not(published_at: nil) }
  scope :finished, -> { where.not(finished_at: nil) }
  scope :ranking_counted, -> { where(ranking_counted: true) }


  def played_3rd_set?
    set3_side1_score.present? || set3_side2_score.present?
  end


  private

  def player_assignments
    nr_assignments = assignments.length
    nr_side1_assignments = assignments.select { |a| a.side == 1 }.length
    nr_side2_assignments = assignments.select { |a| a.side == 2 }.length

    if !nr_assignments.in?([0, 2, 4]) || (nr_side1_assignments != nr_side2_assignments)
      errors.add(:base, "Incorrect players assignments.")
    end
  end


  def set_defaults
    case assignments.length
    when 2
      self.kind = :single
    when 4
      self.kind = :double
    end
  end

end
