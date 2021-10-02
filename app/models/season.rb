class Season < ApplicationRecord

  # Relations ----------
  has_many :tournaments, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :players, through: :enrollments


  # Validations --------
  validates :name,
            presence: true, uniqueness: true

end
