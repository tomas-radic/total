class Manager < ApplicationRecord

  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable, :recoverable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :validatable, :trackable


  # Relations
  has_many :articles, dependent: :restrict_with_error

end
