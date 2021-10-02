class Season < ApplicationRecord

  # Relations ----------
  has_many :tournaments, dependent: :destroy

  # Validations --------
  validates :name,
            presence: true, uniqueness: true

end
