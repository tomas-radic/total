class Place < ApplicationRecord

  # Relations -----
  has_many :matches, dependent: :nullify
  has_many :tournaments, dependent: :nullify


  # Validations -----
  validates :name, presence: true, uniqueness: true

end
