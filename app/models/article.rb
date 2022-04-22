class Article < ApplicationRecord

  include ColorBase

  before_validation :set_random_color_base


  # Scopes -----
  scope :published, -> { where.not(published_at: nil) }
  scope :sorted, -> { order(created_at: :desc) }


  # Validation -----
  validates :title, :content, :color_base,
            presence: true


  # Relations -----
  belongs_to :manager
  belongs_to :season

end
