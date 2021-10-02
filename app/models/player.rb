class Player < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  # Relations -----
  has_many :enrollments, dependent: :destroy
  has_many :seasons, through: :enrollments

  # Validations -----
  validates :phone_nr, uniqueness: true
  validates :name,
            presence: true, uniqueness: true

end
