class Season < ApplicationRecord

  acts_as_list

  # Relations ----------
  has_many :tournaments, dependent: :restrict_with_error
  has_many :enrollments, dependent: :restrict_with_error
  has_many :players, through: :enrollments
  has_many :matches, as: :competitable, dependent: :restrict_with_error


  # Validations --------
  validates :name,
            presence: true, uniqueness: true
  validates :play_off_size,
            :points_single_20,
            :points_single_21,
            :points_single_12,
            :points_single_02,
            :points_double_20,
            :points_double_21,
            :points_double_12,
            :points_double_02,
            presence: true

  validates :ended_at,
            presence: true,
            if: Proc.new { |s| Season.where.not(id: s.id).where(ended_at: nil).exists? }


  # Scopes -----
  scope :sorted, -> { order(position: :desc) }
  scope :ended, -> { where.not(ended_at: nil) }

end
