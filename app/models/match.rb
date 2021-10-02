class Match < ApplicationRecord

  # Relations -----
  belongs_to :competitable, polymorphic: true
  has_many :assignments, dependent: :destroy
  has_many :players, through: :assignments


  # Validations -----
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


  private

  def player_assignments
    if assignments.select { |a| a.side == 1 }.length != assignments.select { |a| a.side == 2 }.length
      errors.add(:base, "Incorrect players assignments.")
    end
  end

end
