class Season < ApplicationRecord

  # Relations ----------
  has_many :tournaments, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :players, through: :enrollments
  has_many :matches, as: :competitable


  # Validations --------
  validates :name,
            presence: true, uniqueness: true
  validates :points_single_20,
            :points_single_21,
            :points_single_12,
            :points_single_02,
            :points_double_20,
            :points_double_21,
            :points_double_12,
            :points_double_02,
            presence: true

end
