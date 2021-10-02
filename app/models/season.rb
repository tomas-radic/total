class Season < ApplicationRecord

  # Relations ----------
  has_many :tournaments, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :players, through: :enrollments
  has_many :matches, as: :competitable


  # Validations --------
  validates :name,
            presence: true, uniqueness: true

end
